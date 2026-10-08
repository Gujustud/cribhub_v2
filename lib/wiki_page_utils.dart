import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';

import 'wiki_table_models.dart';
import 'wiki_table_view.dart';

Map<String, dynamic> wikiData(RecordModel page) {
  return page.data;
}

String wikiTitle(RecordModel page) {
  return (page.data['title'] ?? '').toString().trim();
}

String wikiBody(RecordModel page) {
  return (page.data['body'] ?? '').toString();
}

String wikiVisibility(RecordModel page) {
  final v = (page.data['visibility'] ?? 'everyone').toString();
  if (v == 'staff' || v == 'owner' || v == 'everyone') return v;
  return 'everyone';
}

String wikiVisibilityLabel(String visibility) {
  switch (visibility) {
    case 'staff':
      return 'Office';
    case 'owner':
      return 'Owner';
    default:
      return 'Everyone';
  }
}

int wikiSortOrder(RecordModel page) {
  final v = page.data['sort_order'];
  if (v is int) return v;
  return int.tryParse('$v') ?? 0;
}

String wikiUpdatedEmail(RecordModel page) {
  return (page.data['updated_by_email'] ?? '').toString().trim();
}

String wikiUpdatedName(RecordModel page) {
  return (page.data['updated_by_name'] ?? '').toString().trim();
}

/// Display name for last editor (name, else email).
String wikiUpdatedByLabel(RecordModel page) {
  final name = wikiUpdatedName(page);
  if (name.isNotEmpty) return name;
  return wikiUpdatedEmail(page);
}

String? wikiParentId(RecordModel page) {
  final v = page.data['parent'];
  if (v == null) return null;
  final s = v.toString().trim();
  return s.isEmpty ? null : s;
}

List<String> wikiAttachmentNames(RecordModel page) {
  final v = page.data['attachments'];
  if (v is List) {
    return v.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
  }
  if (v == null) return [];
  final s = v.toString();
  return s.isEmpty ? [] : [s];
}

int wikiCompare(RecordModel a, RecordModel b) {
  final so = wikiSortOrder(a).compareTo(wikiSortOrder(b));
  if (so != 0) return so;
  return wikiTitle(a).toLowerCase().compareTo(wikiTitle(b).toLowerCase());
}

Map<String?, List<RecordModel>> wikiChildrenMap(List<RecordModel> pages) {
  final map = <String?, List<RecordModel>>{};
  for (final p in pages) {
    final parent = wikiParentId(p);
    map.putIfAbsent(parent, () => []).add(p);
  }
  for (final list in map.values) {
    list.sort(wikiCompare);
  }
  return map;
}

List<RecordModel> wikiRoots(List<RecordModel> pages) {
  return wikiChildrenMap(pages)[null] ?? [];
}

Set<String> wikiDescendantIds(List<RecordModel> pages, String id) {
  final children = wikiChildrenMap(pages);
  final out = <String>{};
  void walk(String pid) {
    for (final c in children[pid] ?? const <RecordModel>[]) {
      if (out.add(c.id)) walk(c.id);
    }
  }

  walk(id);
  return out;
}

/// Parent chain above [id] (not including [id] itself).
Set<String> wikiAncestorIds(List<RecordModel> pages, String id) {
  final byId = {for (final p in pages) p.id: p};
  final out = <String>{};
  var cur = byId[id];
  while (cur != null) {
    final parent = wikiParentId(cur);
    if (parent == null || !byId.containsKey(parent)) break;
    if (!out.add(parent)) break;
    cur = byId[parent];
  }
  return out;
}

bool wikiMatchesQuery(RecordModel page, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return true;
  return wikiTitle(page).toLowerCase().contains(q) ||
      wikiBody(page).toLowerCase().contains(q);
}

/// Keep ancestors of matches so the tree still makes sense while searching.
Set<String> wikiVisibleIds(List<RecordModel> pages, String query) {
  if (query.trim().isEmpty) {
    return pages.map((p) => p.id).toSet();
  }
  final byId = {for (final p in pages) p.id: p};
  final ids = <String>{};
  for (final p in pages) {
    if (!wikiMatchesQuery(p, query)) continue;
    var cur = p;
    ids.add(cur.id);
    while (true) {
      final parent = wikiParentId(cur);
      if (parent == null || !byId.containsKey(parent)) break;
      if (!ids.add(parent)) break;
      cur = byId[parent]!;
    }
  }
  return ids;
}

/// Markdown bold must wrap the text, not the `<u>` tags. Rewrites the common mistake.
String wikiPrepareMarkdown(String markdown) {
  return markdown.replaceAllMapped(
    RegExp(r'\*\*<u>([\s\S]*?)</u>\*\*'),
    (m) => '<u>**${m[1]}**</u>',
  );
}

Widget wikiMarkdownView(BuildContext context, String markdown) {
  final prepared = wikiPrepareMarkdown(markdown);
  final styleSheet = MarkdownStyleSheet.fromTheme(Theme.of(context));
  styleSheet.styles['u'] = (styleSheet.p ?? const TextStyle()).copyWith(
    decoration: TextDecoration.underline,
  );

  // Cap wide screens so a single photo doesn't dominate the page.
  final maxImageWidth =
      (MediaQuery.sizeOf(context).width * 0.9).clamp(240.0, 720.0);

  return MarkdownBody(
    data: prepared.isEmpty ? '_No content yet._' : prepared,
    selectable: true,
    softLineBreak: true,
    styleSheet: styleSheet,
    extensionSet: md.ExtensionSet(
      md.ExtensionSet.gitHubFlavored.blockSyntaxes,
      <md.InlineSyntax>[
        _WikiUnderlineSyntax(),
        ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
      ],
    ),
    sizedImageBuilder: (config) => _WikiMarkdownImage(
      config: config,
      maxWidth: maxImageWidth,
    ),
    onTapLink: (text, href, title) async {
      if (href == null || href.isEmpty) return;
      final uri = Uri.tryParse(href);
      if (uri == null) return;
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    },
  );
}

/// Markdown body with `{{table:id}}` embeds rendered as live [WikiTableEmbed]s.
Widget wikiBodyWithTables(
  BuildContext context,
  String body, {
  bool canEditTables = false,
}) {
  final parts = splitWikiBodyWithTables(body);
  final onlyEmptyText = parts.length == 1 &&
      !parts.first.isTable &&
      (parts.first.markdown ?? '').trim().isEmpty;
  if (onlyEmptyText) {
    return wikiMarkdownView(context, body);
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final part in parts)
        if (part.isTable)
          WikiTableEmbed(
            tableId: part.tableId!,
            canEdit: canEditTables,
          )
        else if ((part.markdown ?? '').trim().isNotEmpty)
          wikiMarkdownView(context, part.markdown!),
    ],
  );
}

/// Renders markdown images with optional `![alt](url#400x300)` sizing.
/// A zero width/height means “auto” for that axis; images are also capped by [maxWidth].
class _WikiMarkdownImage extends StatelessWidget {
  final MarkdownImageConfig config;
  final double maxWidth;

  const _WikiMarkdownImage({
    required this.config,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final requestedW = (config.width != null && config.width! > 0) ? config.width : null;
    final requestedH = (config.height != null && config.height! > 0) ? config.height : null;
    final width = requestedW == null ? null : requestedW.clamp(1.0, maxWidth);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Image.network(
          config.uri.toString(),
          width: width,
          height: requestedH,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Text(
            config.alt?.isNotEmpty == true ? config.alt! : 'Image failed to load',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ),
    );
  }
}

class _WikiUnderlineSyntax extends md.InlineSyntax {
  _WikiUnderlineSyntax() : super(r'<u>([\s\S]*?)</u>');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final inner = match[1] ?? '';
    final children = parser.document.parseInline(inner);
    parser.addNode(md.Element('u', children));
    return true;
  }
}
