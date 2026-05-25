import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'add_tool_screen.dart';
import 'app_drawer.dart';
import 'drawer_behavior.dart';
import 'drawer_data_cache.dart';
import 'inventory_screen.dart';
import 'job_detail_screen.dart';
import 'jobs_screen.dart';
import 'pocketbase_service.dart';
import 'quote_detail_screen.dart';
import 'quote_sidebar.dart';
import 'quotes_screen.dart';
import 'return_dialog.dart';
import 'tracking_link.dart';
import 'ui_breakpoints.dart';

/// Combined inventory + ERP dashboard (DharmaCore `Dashboard.jsx` + tool home).
class CombinedHomeScreen extends StatefulWidget {
  const CombinedHomeScreen({super.key});

  @override
  State<CombinedHomeScreen> createState() => _CombinedHomeScreenState();
}

class _CombinedHomeScreenState extends State<CombinedHomeScreen> with AutoOpenDrawerMixin {
  final _toolSearchController = TextEditingController();
  final _dashboardSearchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<dynamic> _jobs = [];
  List<dynamic> _quotes = [];
  bool _loading = true;
  bool _showQuoteTotals = true;
  String _dashboardSearch = '';

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _dashboardSearchController.addListener(() {
      setState(() => _dashboardSearch = _dashboardSearchController.text);
    });
    _load();
  }

  @override
  void dispose() {
    _toolSearchController.dispose();
    _dashboardSearchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final pb = PocketBaseService();
      final results = await Future.wait([
        pb.getJobs(),
        pb.getQuotes(),
      ]);
      if (mounted) {
        setState(() {
          _jobs = results[0];
          _quotes = results[1];
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading dashboard: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  String _str(dynamic v) => v == null ? '' : v.toString().trim();

  Map<String, dynamic>? _expandData(dynamic expanded) {
    if (expanded == null) return null;
    if (expanded is List && expanded.isNotEmpty) {
      return expanded.first.data as Map<String, dynamic>?;
    }
    if (expanded.data != null) {
      return expanded.data as Map<String, dynamic>?;
    }
    return null;
  }

  String _jobCustomer(dynamic job) {
    final data = job.data as Map<String, dynamic>? ?? {};
    final expand = job.expand;
    if (expand != null && expand['customer'] != null) {
      final c = _expandData(expand['customer']);
      if (c != null) {
        final co = _str(c['company']);
        if (co.isNotEmpty) return co;
        final na = _str(c['name']);
        if (na.isNotEmpty) return na;
      }
    }
    final snap = _str(data['customer_name']);
    return snap.isNotEmpty ? snap : '—';
  }

  String _quoteCustomer(dynamic quote) {
    final data = quote.data as Map<String, dynamic>? ?? {};
    final expand = quote.expand;
    if (expand != null && expand['customer'] != null) {
      final c = _expandData(expand['customer']);
      if (c != null) {
        final co = _str(c['company']);
        if (co.isNotEmpty) return co;
        final na = _str(c['name']);
        if (na.isNotEmpty) return na;
      }
    }
    final snap = _str(data['customer_name']);
    return snap.isNotEmpty ? snap : '—';
  }

  int _jobNumberSortKey(dynamic job) {
    final data = job.data as Map<String, dynamic>? ?? {};
    final s = '${data['job_number'] ?? ''}'.replaceAll(RegExp(r'\D'), '');
    final eight = s.length >= 8 ? s.substring(0, 8) : s;
    if (eight.length != 8) return 0;
    final mm = int.tryParse(eight.substring(0, 2)) ?? 0;
    final dd = int.tryParse(eight.substring(2, 4)) ?? 0;
    final yyyy = int.tryParse(eight.substring(4, 8)) ?? 0;
    final d = DateTime(yyyy, mm, dd);
    return d.millisecondsSinceEpoch;
  }

  DateTime? _parseDateOnly(dynamic raw) {
    if (raw == null || '$raw'.isEmpty) return null;
    final s = raw.toString();
    final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(s);
    if (m != null) {
      return DateTime(int.parse(m[1]!), int.parse(m[2]!), int.parse(m[3]!));
    }
    try {
      return DateTime.parse(s);
    } catch (_) {
      return null;
    }
  }

  bool _inCurrentMonth(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month;
  }

  String _formatCurrency(dynamic n) {
    if (n == null || n == '') return '—';
    final num = double.tryParse(n.toString());
    if (num == null) return '—';
    return NumberFormat.currency(locale: 'en_CA', symbol: r'$', decimalDigits: 0).format(num);
  }

  String _formatShipLabel(dynamic raw) {
    final d = _parseDateOnly(raw);
    if (d == null) return '—';
    return DateFormat('MMM d').format(d);
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _openToolSearch() {
    final q = _toolSearchController.text.trim();
    if (q.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InventoryScreen(initialSearchQuery: q),
      ),
    );
  }

  void _openNewQuote() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QuoteDetailScreen()),
    ).then((changed) {
      if (changed == true) _load();
    });
  }

  ButtonStyle get _greyActionButtonStyle => ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        backgroundColor: Colors.grey[700],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      );

  void _openJob(dynamic job) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JobDetailScreen(job: job)),
    ).then((changed) {
      if (changed == true) _load();
    });
  }

  void _openQuote(dynamic quote) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuoteDetailScreen(quote: quote)),
    ).then((changed) {
      if (changed == true) _load();
    });
  }

  Widget _statCard(String label, String value) {
    final muted = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFD1D5DB)
        : const Color(0xFF4B5563);
    return QuoteSidebarCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: muted)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _jobStatusBadge(String status) {
    final s = status.isEmpty ? 'planning' : status.toLowerCase();
    Color bg;
    Color fg;
    switch (s) {
      case 'in_progress':
        bg = const Color(0xFFFFFBEB);
        fg = const Color(0xFFB45309);
        break;
      case 'done':
        bg = const Color(0xFFD1FAE5);
        fg = const Color(0xFF065F46);
        break;
      case 'cancelled':
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFF991B1B);
        break;
      default:
        bg = const Color(0xFFDBEAFE);
        fg = const Color(0xFF1E40AF);
    }
    if (Theme.of(context).brightness == Brightness.dark) {
      switch (s) {
        case 'in_progress':
          bg = const Color(0xFFD97706);
          fg = Colors.white;
          break;
        case 'done':
          bg = const Color(0xFF059669);
          fg = Colors.white;
          break;
        case 'cancelled':
          bg = const Color(0xFFDC2626);
          fg = Colors.white;
          break;
        default:
          bg = const Color(0xFF2563EB);
          fg = Colors.white;
      }
    }
    final label = switch (s) {
      'in_progress' => 'In progress',
      'done' => 'Done',
      'cancelled' => 'Cancelled',
      'planning' => 'Planning',
      _ => s.replaceAll('_', ' '),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: fg),
      ),
    );
  }

  Widget _quoteStatusBadge(String status) {
    final s = status.isEmpty ? 'draft' : status.toLowerCase();
    Color bg;
    Color fg;
    String label;
    switch (s) {
      case 'sent':
        bg = const Color(0xFFDBEAFE);
        fg = const Color(0xFF1E40AF);
        label = 'sent';
        break;
      case 'won':
        bg = const Color(0xFFD1FAE5);
        fg = const Color(0xFF065F46);
        label = 'won';
        break;
      case 'lost':
        bg = const Color(0xFFD1D5DB);
        fg = const Color(0xFF4B5563);
        label = 'lost';
        break;
      default:
        bg = const Color(0xFFE5E7EB);
        fg = const Color(0xFF1F2937);
        label = 'draft';
    }
    if (Theme.of(context).brightness == Brightness.dark) {
      switch (s) {
        case 'sent':
          bg = const Color(0xFF2563EB);
          fg = Colors.white;
          break;
        case 'won':
          bg = const Color(0xFF059669);
          fg = Colors.white;
          break;
        case 'lost':
          bg = const Color(0xFF6B7280);
          fg = Colors.white;
          break;
        default:
          bg = const Color(0xFF6B7280);
          fg = Colors.white;
      }
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: fg),
      ),
    );
  }

  static const _dashboardColumnWidths = <int, TableColumnWidth>{
    0: FlexColumnWidth(0.18),
    1: FlexColumnWidth(0.48),
    2: FlexColumnWidth(0.18),
    3: FlexColumnWidth(0.16),
  };

  /// Full-width table matching DharmaCore `dashboard-table` (18 / 48 / 18 / 16 %).
  Widget _dashboardTable(List<TableRow> rows) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final table = Table(
          columnWidths: _dashboardColumnWidths,
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: rows,
        );
        final maxW = constraints.maxWidth;
        if (maxW < 520 && maxW > 0) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(width: 520, child: table),
          );
        }
        return SizedBox(width: maxW.isFinite ? maxW : double.infinity, child: table);
      },
    );
  }

  TextStyle _dashboardLinkStyle({FontWeight? weight}) {
    return TextStyle(
      fontWeight: weight ?? FontWeight.w500,
      color: QuoteSidebarTheme.primaryFrom,
      decoration: TextDecoration.underline,
      decorationColor: QuoteSidebarTheme.primaryFrom,
    );
  }

  Widget _dashboardSection({
    required String title,
    required Widget child,
    Widget? trailing,
    EdgeInsetsGeometry? margin,
  }) {
    return Card(
      margin: margin ?? const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  Widget _toolsActionCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _toolSearchController,
              decoration: InputDecoration(
                hintText: 'Search tools…',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Barcode scan coming soon')),
                    );
                  },
                  tooltip: 'Scan barcode/QR',
                ),
              ),
              onSubmitted: (_) => _openToolSearch(),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddToolScreen()),
                    );
                  },
                  style: _greyActionButtonStyle,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 24),
                      SizedBox(width: 8),
                      Text('Add Tool', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    await showDialog<bool>(
                      context: context,
                      builder: (context) => const ReturnDialog(),
                    );
                  },
                  style: _greyActionButtonStyle,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.keyboard_return, size: 24),
                      SizedBox(width: 8),
                      Text('Return', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _jobsActionCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _dashboardSearchController,
              decoration: InputDecoration(
                hintText: 'Search jobs & quotes…',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.search, size: 20),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _openNewQuote,
                  style: _greyActionButtonStyle,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 24),
                      SizedBox(width: 8),
                      Text('New quote', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration? _dashboardRowBorder(BuildContext context) {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF374151)
              : const Color(0xFFF3F4F6),
        ),
      ),
    );
  }

  Widget _activeJobsTable(List<dynamic> jobs) {
    if (jobs.isEmpty) {
      return Text(
        'No active jobs. Jobs appear when a quote is marked Won.',
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      );
    }

    final divider = _dashboardRowBorder(context);
    return _dashboardTable([
      TableRow(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        children: const [
          _TableHeaderCell(Text('Job #')),
          _TableHeaderCell(Text('Customer')),
          _TableHeaderCell(Text('Status')),
          _TableHeaderCell(Text('Ship date')),
        ],
      ),
      ...jobs.map((job) {
        final data = job.data as Map<String, dynamic>? ?? {};
        final status = _str(data['status']);
        final st = status.isEmpty ? 'planning' : status;
        final jobNum = _str(data['job_number']);
        final customer = _jobCustomer(job);
        final trackingUrl = generateTrackingLink('${data['tracking_number_1'] ?? ''}');
        final shipLabel = _formatShipLabel(data['ship_date']);
        final hasLink = shipLabel != '—' && trackingUrl.isNotEmpty;

        return TableRow(
          decoration: divider,
          children: [
            _TableDataCell(
              child: InkWell(
                onTap: () => _openJob(job),
                child: Text(
                  jobNum.isEmpty ? '—' : jobNum,
                  style: _dashboardLinkStyle(weight: FontWeight.w600),
                ),
              ),
            ),
            _TableDataCell(
              child: InkWell(
                onTap: () => _openJob(job),
                child: Text(
                  customer,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _dashboardLinkStyle(),
                ),
              ),
            ),
            _TableDataCell(child: Align(alignment: Alignment.centerLeft, child: _jobStatusBadge(st))),
            _TableDataCell(
              child: hasLink
                  ? InkWell(
                      onTap: () => _openUrl(trackingUrl),
                      child: Text(shipLabel, style: _dashboardLinkStyle()),
                    )
                  : Text(shipLabel, style: const TextStyle(fontSize: 14)),
            ),
          ],
        );
      }),
    ]);
  }

  Widget _recentQuotesTable(List<dynamic> quotes) {
    if (quotes.isEmpty) {
      return Text(
        'No quotes yet. Create one from Quotes.',
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      );
    }

    final divider = _dashboardRowBorder(context);
    return _dashboardTable([
      TableRow(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        children: [
          const _TableHeaderCell(Text('Job #')),
          const _TableHeaderCell(Text('Customer')),
          const _TableHeaderCell(Text('Status')),
          _TableHeaderCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Flexible(
                  child: Text('Total (CAD)', overflow: TextOverflow.ellipsis),
                ),
                IconButton(
                  icon: Icon(
                    _showQuoteTotals ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 16,
                  ),
                  onPressed: () => setState(() => _showQuoteTotals = !_showQuoteTotals),
                  tooltip: _showQuoteTotals ? 'Hide totals' : 'Show totals',
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                ),
              ],
            ),
          ),
        ],
      ),
      ...quotes.map((quote) {
        final data = quote.data as Map<String, dynamic>? ?? {};
        final jobNum = _str(data['job_number']);
        final status = _str(data['status']);
        final st = status.isEmpty ? 'draft' : status;
        return TableRow(
          decoration: divider,
          children: [
            _TableDataCell(
              child: InkWell(
                onTap: () => _openQuote(quote),
                child: Text(
                  jobNum.isEmpty ? '—' : jobNum,
                  style: _dashboardLinkStyle(weight: FontWeight.w600),
                ),
              ),
            ),
            _TableDataCell(
              child: InkWell(
                onTap: () => _openQuote(quote),
                child: Text(
                  _quoteCustomer(quote),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _dashboardLinkStyle(),
                ),
              ),
            ),
            _TableDataCell(child: Align(alignment: Alignment.centerLeft, child: _quoteStatusBadge(st))),
            _TableDataCell(
              child: Text(
                _showQuoteTotals ? _formatCurrency(data['final_total_cad']) : '—',
                style: const TextStyle(fontSize: 14, fontFeatures: [FontFeature.tabularFigures()]),
              ),
            ),
          ],
        );
      }),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    maybeAutoOpenDrawer();

    final wide = MediaQuery.sizeOf(context).width >= kWorkspaceWideBreakpointPx;
    final usePermanentDrawer = wide && DrawerDataCache.keepDrawerOpen;

    final searchLower = _dashboardSearch.trim().toLowerCase();

    final activeJobsAll = _jobs.where((j) {
      final st = _str((j.data as Map?)?['status']);
      return st == 'planning' || st == 'in_progress';
    }).toList()
      ..sort((a, b) {
        final cmp = _jobNumberSortKey(b).compareTo(_jobNumberSortKey(a));
        if (cmp != 0) return cmp;
        final an = _str((a.data as Map?)?['job_number']);
        final bn = _str((b.data as Map?)?['job_number']);
        return bn.compareTo(an);
      });

    final activeJobs = searchLower.isEmpty
        ? activeJobsAll
        : activeJobsAll.where((j) {
            final data = j.data as Map<String, dynamic>? ?? {};
            final jobNum = _str(data['job_number']).toLowerCase();
            final cust = _jobCustomer(j).toLowerCase();
            return jobNum.contains(searchLower) || cust.contains(searchLower);
          }).toList();

    final inProgressCount = _jobs.where((j) => _str((j.data as Map?)?['status']) == 'in_progress').length;
    final doneJobs = _jobs.where((j) => _str((j.data as Map?)?['status']) == 'done').toList();
    final doneThisMonth = doneJobs.where((j) {
      final data = j.data as Map<String, dynamic>? ?? {};
      final d = _parseDateOnly(data['completion_date']) ??
          _parseDateOnly(data['updated']);
      return d != null && _inCurrentMonth(d);
    }).length;

    final recentQuotesAll = [..._quotes]
      ..sort((a, b) {
        final cmp = _jobNumberSortKey(b).compareTo(_jobNumberSortKey(a));
        if (cmp != 0) return cmp;
        final an = _str((a.data as Map?)?['job_number']);
        final bn = _str((b.data as Map?)?['job_number']);
        return bn.compareTo(an);
      });
    final recentQuotesSlice = recentQuotesAll.take(6).toList();
    final recentQuotes = searchLower.isEmpty
        ? recentQuotesSlice
        : recentQuotesSlice.where((q) {
            final data = q.data as Map<String, dynamic>? ?? {};
            final jobNum = _str(data['job_number']).toLowerCase();
            final cust = _quoteCustomer(q).toLowerCase();
            return jobNum.contains(searchLower) || cust.contains(searchLower);
          }).toList();

    final body = RefreshIndicator(
      onRefresh: _load,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Dashboard',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth >= 640) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _toolsActionCard(context)),
                          const SizedBox(width: 16),
                          Expanded(child: _jobsActionCard(context)),
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _toolsActionCard(context),
                        const SizedBox(height: 16),
                        _jobsActionCard(context),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                if (_loading)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else ...[
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth >= 700) {
                        return IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: _statCard('Active', '${activeJobsAll.length}')),
                              const SizedBox(width: 12),
                              Expanded(child: _statCard('In progress', '$inProgressCount')),
                              const SizedBox(width: 12),
                              Expanded(child: _statCard('Done', '${doneJobs.length}')),
                              const SizedBox(width: 12),
                              Expanded(child: _statCard('This Month', '$doneThisMonth')),
                            ],
                          ),
                        );
                      }
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _statCard('Active', '${activeJobsAll.length}')),
                              const SizedBox(width: 12),
                              Expanded(child: _statCard('In progress', '$inProgressCount')),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _statCard('Done', '${doneJobs.length}')),
                              const SizedBox(width: 12),
                              Expanded(child: _statCard('This Month', '$doneThisMonth')),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  _dashboardSection(
                    title: 'Active Jobs',
                    margin: const EdgeInsets.only(top: 24),
                    trailing: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const JobsScreen()),
                        );
                      },
                      child: const Text('All jobs'),
                    ),
                    child: _activeJobsTable(activeJobs),
                  ),
                  _dashboardSection(
                    title: 'Recent Quotes',
                    trailing: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const QuotesScreen()),
                        );
                      },
                      child: const Text('All quotes'),
                    ),
                    child: _recentQuotesTable(recentQuotes),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Cribhub'),
        leading: usePermanentDrawer
            ? null
            : Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
      ),
      drawer: usePermanentDrawer ? null : const AppDrawer(),
      body: usePermanentDrawer
          ? Row(
              children: [
                const AppDrawer(asDrawer: false, closeOnTap: false),
                const VerticalDivider(width: 1),
                Expanded(child: body),
              ],
            )
          : body,
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  final Widget child;

  const _TableHeaderCell(this.child);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 12),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        child: child,
      ),
    );
  }
}

class _TableDataCell extends StatelessWidget {
  final Widget child;

  const _TableDataCell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
      child: child,
    );
  }
}
