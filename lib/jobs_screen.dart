import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app_drawer.dart';
import 'drawer_behavior.dart';
import 'job_detail_screen.dart';
import 'pocketbase_service.dart';
import 'quote_detail_screen.dart';
import 'quote_sidebar.dart';

/// All jobs list (layout aligned with [QuotesScreen]).
class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> with AutoOpenDrawerMixin {
  List<dynamic> _jobs = [];
  bool _isLoading = true;
  String _search = '';
  String _searchDebounced = '';
  String _statusFilter = '';
  String _sortKey = 'job_number';
  String _sortDir = 'desc';
  Timer? _searchDebounce;

  final _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static final _dateDisplay = DateFormat.yMMMd();

  @override
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final jobs = await PocketBaseService().getJobs();
      if (mounted) {
        setState(() {
          _jobs = jobs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading jobs: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _onSearchChanged(String value) {
    setState(() => _search = value);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _searchDebounced = _search);
    });
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

  String _customerDisplay(dynamic job) {
    final data = job.data as Map<String, dynamic>? ?? {};
    final expand = job.expand;
    if (expand != null && expand['customer'] != null) {
      final cData = _expandData(expand['customer']);
      if (cData != null) {
        final company = _str(cData['company']);
        if (company.isNotEmpty) return company;
        final name = _str(cData['name']);
        if (name.isNotEmpty) return name;
      }
    }
    final snap = _str(data['customer_name']);
    if (snap.isNotEmpty) return snap;
    return '—';
  }

  /// Quote record from expand, or null.
  dynamic _expandedQuote(dynamic job) {
    final expand = job.expand;
    if (expand == null || expand['quote'] == null) return null;
    final q = expand['quote'];
    if (q is List && q.isNotEmpty) return q.first;
    return q;
  }

  String _linkedQuoteLabel(dynamic job) {
    final q = _expandedQuote(job);
    if (q == null) return '—';
    final d = q.data as Map<String, dynamic>? ?? {};
    final jn = _str(d['job_number']);
    return jn.isNotEmpty ? jn : 'Quote';
  }

  DateTime? _jobCreated(dynamic job) {
    final raw = job.created ?? job.updated;
    if (raw == null) return null;
    try {
      return DateTime.parse(raw.toString());
    } catch (_) {
      return null;
    }
  }

  DateTime? _parseDue(dynamic v) {
    if (v == null || v.toString().isEmpty) return null;
    try {
      return DateTime.parse(v.toString());
    } catch (_) {
      return null;
    }
  }

  int _jobNumberToSortKey(String? jobNumber) {
    final s = (jobNumber ?? '').replaceAll(RegExp(r'\D'), '');
    final eight = s.length >= 8 ? s.substring(0, 8) : s;
    if (eight.length != 8) return 0;
    final mm = int.tryParse(eight.substring(0, 2)) ?? 0;
    final dd = int.tryParse(eight.substring(2, 4)) ?? 0;
    final yyyy = int.tryParse(eight.substring(4, 8)) ?? 0;
    return DateTime(yyyy, mm, dd).millisecondsSinceEpoch;
  }

  List<dynamic> get _filteredJobs {
    final searchLower = _searchDebounced.trim().toLowerCase();
    var list = _jobs.where((job) {
      final data = job.data as Map<String, dynamic>? ?? {};
      if (_statusFilter.isNotEmpty && _str(data['status']) != _statusFilter) {
        return false;
      }
      if (searchLower.isEmpty) return true;
      final fields = [
        data['job_number'],
        data['customer_name'],
        data['parts_description'],
        _customerDisplay(job),
        _linkedQuoteLabel(job),
      ];
      return fields.any((v) => _str(v).toLowerCase().contains(searchLower));
    }).toList();

    final mult = _sortDir == 'asc' ? 1 : -1;
    list.sort((a, b) {
      final ad = a.data as Map<String, dynamic>? ?? {};
      final bd = b.data as Map<String, dynamic>? ?? {};
      if (_sortKey == 'job_number') {
        final ta = _jobNumberToSortKey(ad['job_number']?.toString());
        final tb = _jobNumberToSortKey(bd['job_number']?.toString());
        final cmp = _sortDir == 'desc' ? tb.compareTo(ta) : ta.compareTo(tb);
        if (cmp != 0) return cmp;
        return _sortDir == 'desc'
            ? _str(bd['job_number']).compareTo(_str(ad['job_number']))
            : _str(ad['job_number']).compareTo(_str(bd['job_number']));
      }
      if (_sortKey == 'customer') {
        return mult * _customerDisplay(a).compareTo(_customerDisplay(b));
      }
      if (_sortKey == 'due_date') {
        final da = _parseDue(ad['due_date'])?.millisecondsSinceEpoch ?? 0;
        final db = _parseDue(bd['due_date'])?.millisecondsSinceEpoch ?? 0;
        return mult * da.compareTo(db);
      }
      if (_sortKey == 'status') {
        return mult * _str(ad['status']).compareTo(_str(bd['status']));
      }
      return 0;
    });
    return list;
  }

  Future<void> _deleteJob(dynamic job) async {
    final data = job.data as Map<String, dynamic>? ?? {};
    final label = _str(data['job_number']).isEmpty ? 'this job' : data['job_number'];
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete job?'),
        content: Text('Delete job $label? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await PocketBaseService().deleteJob(job.id);
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job deleted'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _openJob(dynamic job) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => JobDetailScreen(job: job)),
    );
    if (changed == true) _loadData();
  }

  Future<void> _openLinkedQuote(dynamic job) async {
    final q = _expandedQuote(job);
    if (q == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No linked quote on this job')),
      );
      return;
    }
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => QuoteDetailScreen(quote: q)),
    );
    if (changed == true) _loadData();
  }

  Future<void> _newJob() async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const JobDetailScreen()),
    );
    if (changed == true) _loadData();
  }

  Widget _statCard(String label, String value) {
    final muted = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFD1D5DB)
        : const Color(0xFF4B5563);
    return QuoteSidebarCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: muted)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _statsRow(int thisMonth, int inProgress, int done, int cancelled) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 700) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _statCard('Jobs this month', '$thisMonth')),
                const SizedBox(width: 12),
                Expanded(child: _statCard('In progress', '$inProgress')),
                const SizedBox(width: 12),
                Expanded(child: _statCard('Done', '$done')),
                const SizedBox(width: 12),
                Expanded(child: _statCard('Cancelled', '$cancelled')),
              ],
            ),
          );
        }
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: _statCard('Jobs this month', '$thisMonth')),
                const SizedBox(width: 12),
                Expanded(child: _statCard('In progress', '$inProgress')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _statCard('Done', '$done')),
                const SizedBox(width: 12),
                Expanded(child: _statCard('Cancelled', '$cancelled')),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _statusFilterDropdown() {
    return SizedBox(
      width: 180,
      child: DropdownButtonFormField<String>(
        initialValue: _statusFilter.isEmpty ? '' : _statusFilter,
        decoration: QuoteSidebarTheme.fieldDecoration(context).copyWith(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: const [
          DropdownMenuItem(value: '', child: Text('All statuses')),
          DropdownMenuItem(value: 'planning', child: Text('Planning')),
          DropdownMenuItem(value: 'in_progress', child: Text('In progress')),
          DropdownMenuItem(value: 'done', child: Text('Done')),
          DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
        ],
        onChanged: (v) => setState(() => _statusFilter = v ?? ''),
      ),
    );
  }

  Color _tableBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF374151)
        : const Color(0xFFE5E7EB);
  }

  Color _tableHoverColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF374151).withValues(alpha: 0.5)
        : const Color(0xFFF9FAFB);
  }

  TextStyle _tableHeaderStyle(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF9CA3AF)
        : const Color(0xFF4B5563);
    return TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: muted);
  }

  Widget _jobStatusBadge(String status) {
    final s = status.isEmpty ? 'planning' : status.toLowerCase();
    Color bg;
    Color fg;
    switch (s) {
      case 'in_progress':
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFF92400E);
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
    final label = s.replaceAll('_', ' ');
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

  Widget _sortLink(String label, String key, {String? defaultDir}) {
    final active = _sortKey == key;
    final titleColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF111827);
    final color = active
        ? titleColor
        : (Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF9CA3AF)
            : const Color(0xFF4B5563));
    return InkWell(
      onTap: () {
        setState(() {
          if (_sortKey == key) {
            _sortDir = _sortDir == 'asc' ? 'desc' : 'asc';
          } else {
            _sortKey = key;
            _sortDir = defaultDir ?? 'asc';
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color),
        ),
      ),
    );
  }

  Widget _tableHeaderRow(BuildContext context) {
    final border = _tableBorderColor(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: border)),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('Job #', style: _tableHeaderStyle(context))),
          Expanded(flex: 3, child: Text('Customer', style: _tableHeaderStyle(context))),
          Expanded(flex: 2, child: Text('Status', style: _tableHeaderStyle(context))),
          Expanded(flex: 2, child: Text('Due', style: _tableHeaderStyle(context))),
          Expanded(flex: 2, child: Text('Quote', style: _tableHeaderStyle(context))),
          Expanded(flex: 4, child: Text('Actions', style: _tableHeaderStyle(context))),
        ],
      ),
    );
  }

  Widget _tableDataRow(BuildContext context, dynamic job) {
    final data = job.data as Map<String, dynamic>? ?? {};
    final status = _str(data['status']);
    final jobNum = _str(data['job_number']);
    final due = _parseDue(data['due_date']);
    final dueStr = due != null ? _dateDisplay.format(due) : '—';
    final hasQuote = _expandedQuote(job) != null;
    final border = _tableBorderColor(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        hoverColor: _tableHoverColor(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: border.withValues(alpha: 0.6))),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () => _openJob(job),
                  child: Text(
                    jobNum.isEmpty ? '—' : jobNum,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: QuoteSidebarTheme.primaryFrom,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  _customerDisplay(job),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IntrinsicWidth(child: _jobStatusBadge(status)),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(dueStr),
              ),
              Expanded(
                flex: 2,
                child: hasQuote
                    ? GestureDetector(
                        onTap: () => _openLinkedQuote(job),
                        child: Text(
                          _linkedQuoteLabel(job),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: QuoteSidebarTheme.primaryFrom,
                          ),
                        ),
                      )
                    : const Text('—'),
              ),
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      QuoteTableActionButton(
                        label: 'View',
                        onPressed: () => _openJob(job),
                      ),
                      if (hasQuote) ...[
                        const SizedBox(width: 6),
                        QuoteTableActionButton(
                          label: 'View quote',
                          onPressed: () => _openLinkedQuote(job),
                        ),
                      ],
                      const SizedBox(width: 6),
                      QuoteTableActionButton(
                        label: 'Delete',
                        danger: true,
                        onPressed: () => _deleteJob(job),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _jobsTable(BuildContext context, List<dynamic> filtered) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _tableHeaderRow(context),
        ...filtered.map((j) => _tableDataRow(context, j)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    maybeAutoOpenDrawer();

    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    var thisMonth = 0;
    var inProgress = 0;
    var done = 0;
    var cancelled = 0;

    for (final job in _jobs) {
      final data = job.data as Map<String, dynamic>? ?? {};
      final st = _str(data['status']);
      if (st == 'in_progress') inProgress++;
      if (st == 'done') done++;
      if (st == 'cancelled') cancelled++;

      final created = _jobCreated(job);
      if (created != null &&
          !created.isBefore(monthStart) &&
          !created.isAfter(monthEnd)) {
        thisMonth++;
      }
    }

    final filtered = _filteredJobs;
    final titleColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF111827);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('All Jobs'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      SizedBox(
                        width: 220,
                        child: TextField(
                          controller: _searchController,
                          decoration: QuoteSidebarTheme.fieldDecoration(context).copyWith(
                            hintText: 'Search…',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          onChanged: _onSearchChanged,
                        ),
                      ),
                      const SizedBox(width: 12),
                      QuoteSidebarPrimaryButton(
                        label: 'New job',
                        onPressed: _newJob,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _statsRow(thisMonth, inProgress, done, cancelled),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _statusFilterDropdown(),
                      Container(
                        width: 1,
                        height: 28,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        color: _tableBorderColor(context),
                      ),
                      _sortLink('Job #', 'job_number', defaultDir: 'desc'),
                      _sortLink('Customer', 'customer', defaultDir: 'asc'),
                      _sortLink('Due', 'due_date', defaultDir: 'asc'),
                      _sortLink('Status', 'status', defaultDir: 'asc'),
                      Text(
                        'Order',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => _sortDir = 'asc'),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            'A→Z',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _sortDir == 'asc' ? titleColor : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => _sortDir = 'desc'),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            'Z→A',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _sortDir == 'desc' ? titleColor : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  QuoteSidebarCard(
                    padding: EdgeInsets.zero,
                    child: _isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(32),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : filtered.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(32),
                                child: Center(
                                  child: Text(
                                    _jobs.isEmpty
                                        ? 'No jobs yet. Create one to get started.'
                                        : 'No jobs match your search or filter.',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ),
                              )
                            : _jobsTable(context, filtered),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
