import 'package:flutter/material.dart';

import 'app_drawer.dart';
import 'dashboard_navigation.dart';
import 'workspace_layout.dart';

/// Standard app shell: optional pinned side menu + [Scaffold] content.
class WorkspaceScaffold extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool resizeToAvoidBottomInset;

  const WorkspaceScaffold({
    super.key,
    this.scaffoldKey,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    if (usePinnedDrawer(context)) {
      final bar = appBar is AppBar ? appBar! as AppBar : null;
      final pageTitle = _titleText(bar?.title);
      final actions = bar?.actions ?? const <Widget>[];
      final bottom = bar?.bottom;

      return Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            WorkspaceTopBar(
              pageTitle: pageTitle,
              actions: actions,
            ),
            if (bottom != null) bottom,
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AppDrawer(
                    asDrawer: false,
                    closeOnTap: false,
                    showBrandHeader: false,
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: body),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: _overlayAppBar(context, appBar),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      drawer: workspaceDrawer(context),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: body,
    );
  }

  PreferredSizeWidget? _overlayAppBar(
    BuildContext context,
    PreferredSizeWidget? bar,
  ) {
    if (bar == null) return null;
    if (bar is! AppBar) return bar;
    return AppBar(
      title: bar.title,
      actions: bar.actions,
      backgroundColor: bar.backgroundColor,
      foregroundColor: bar.foregroundColor,
      bottom: bar.bottom,
      leading: workspaceMenuLeading(context),
      automaticallyImplyLeading: false,
    );
  }

  static String _titleText(Widget? title) {
    if (title == null) return '';
    if (title is Text) return title.data ?? '';
    return '';
  }
}

/// Full-width top row when the side menu is pinned: brand left, page title right.
class WorkspaceTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;
  final List<Widget> actions;

  const WorkspaceTopBar({
    super.key,
    required this.pageTitle,
    this.actions = const [],
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appBarTheme = theme.appBarTheme;
    final bg = colorScheme.inversePrimary;
    final fg = appBarTheme.foregroundColor ?? colorScheme.onSurface;

    return Material(
      color: bg,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight,
          child: Row(
            children: [
              SizedBox(
                width: kAppDrawerWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => goToDashboard(context),
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          'DharmaCore',
                          style: TextStyle(
                            color: fg,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: pageTitle.isEmpty ||
                            pageTitle.toLowerCase() == 'dharmacore'
                        ? const SizedBox.shrink()
                        : Text(
                            pageTitle,
                            style: TextStyle(
                              color: fg,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                ),
              ),
              ...actions,
            ],
          ),
        ),
      ),
    );
  }
}
