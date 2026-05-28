import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Mouse drags job cards; touch/stylus scrolls the board horizontally.
class _KanbanScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
      };
}

/// Kanban columns aligned with DharmaCore [JobsBoard.jsx].
class JobsKanbanColumn {
  final String id;
  final String label;
  final Color lightBg;
  final Color lightBorder;
  final Color lightFg;

  const JobsKanbanColumn({
    required this.id,
    required this.label,
    required this.lightBg,
    required this.lightBorder,
    required this.lightFg,
  });
}

const kJobsKanbanColumns = [
  JobsKanbanColumn(
    id: 'planning',
    label: 'Planning',
    lightBg: Color(0xFFEFF6FF),
    lightBorder: Color(0xFFBFDBFE),
    lightFg: Color(0xFF1E40AF),
  ),
  JobsKanbanColumn(
    id: 'in_progress',
    label: 'In progress',
    lightBg: Color(0xFFFFFBEB),
    lightBorder: Color(0xFFFDE68A),
    lightFg: Color(0xFFB45309),
  ),
  JobsKanbanColumn(
    id: 'done',
    label: 'Done',
    lightBg: Color(0xFFD1FAE5),
    lightBorder: Color(0xFF6EE7B7),
    lightFg: Color(0xFF065F46),
  ),
  JobsKanbanColumn(
    id: 'cancelled',
    label: 'Cancelled',
    lightBg: Color(0xFFF3F4F6),
    lightBorder: Color(0xFFE5E7EB),
    lightFg: Color(0xFF374151),
  ),
];

/// Four-column jobs board with drag-to-change-status.
class JobsKanbanBoard extends StatefulWidget {
  final List<dynamic> jobs;
  final String Function(dynamic job) customerLabel;
  final String Function(dynamic job) jobNumber;
  final void Function(dynamic job) onOpenJob;
  final Future<void> Function(String jobId, String newStatus) onStatusChange;

  const JobsKanbanBoard({
    super.key,
    required this.jobs,
    required this.customerLabel,
    required this.jobNumber,
    required this.onOpenJob,
    required this.onStatusChange,
  });

  @override
  State<JobsKanbanBoard> createState() => _JobsKanbanBoardState();
}

class _JobsKanbanBoardState extends State<JobsKanbanBoard> {
  String? _draggingJobId;

  Map<String, List<dynamic>> _jobsByStatus() {
    final map = {for (final c in kJobsKanbanColumns) c.id: <dynamic>[]};
    for (final job in widget.jobs) {
      final data = job.data as Map<String, dynamic>? ?? {};
      final st = (data['status']?.toString() ?? 'planning').trim();
      final key = map.containsKey(st) ? st : 'planning';
      map[key]!.add(job);
    }
    return map;
  }

  Widget _buildColumn(
    JobsKanbanColumn col,
    List<dynamic> columnJobs,
    bool isDark, {
    double? width,
  }) {
    return _KanbanColumn(
      column: col,
      width: width,
      isDark: isDark,
      jobs: columnJobs,
      draggingJobId: _draggingJobId,
      customerLabel: widget.customerLabel,
      jobNumber: widget.jobNumber,
      onOpenJob: widget.onOpenJob,
      onDragStarted: (id) => setState(() => _draggingJobId = id),
      onDragEnded: () => setState(() => _draggingJobId = null),
      onAccept: (jobId) => widget.onStatusChange(jobId, col.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final byStatus = _jobsByStatus();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Match stat cards: four equal columns with 12px gaps on wide layouts.
        if (constraints.maxWidth >= 700) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < kJobsKanbanColumns.length; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                Expanded(
                  child: _buildColumn(
                    kJobsKanbanColumns[i],
                    byStatus[kJobsKanbanColumns[i].id] ?? [],
                    isDark,
                  ),
                ),
              ],
            ],
          );
        }

        return ScrollConfiguration(
          behavior: _KanbanScrollBehavior(),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: kJobsKanbanColumns.map((col) {
                final columnJobs = byStatus[col.id] ?? [];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _buildColumn(col, columnJobs, isDark, width: 260),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class _KanbanColumn extends StatelessWidget {
  final JobsKanbanColumn column;
  final double? width;
  final bool isDark;
  final List<dynamic> jobs;
  final String? draggingJobId;
  final String Function(dynamic job) customerLabel;
  final String Function(dynamic job) jobNumber;
  final void Function(dynamic job) onOpenJob;
  final void Function(String jobId) onDragStarted;
  final VoidCallback onDragEnded;
  final Future<void> Function(String jobId) onAccept;

  const _KanbanColumn({
    required this.column,
    this.width,
    required this.isDark,
    required this.jobs,
    required this.draggingJobId,
    required this.customerLabel,
    required this.jobNumber,
    required this.onOpenJob,
    required this.onDragStarted,
    required this.onDragEnded,
    required this.onAccept,
  });

  Color _columnBg() {
    if (isDark) {
      switch (column.id) {
        case 'in_progress':
          return const Color(0xFFD97706);
        case 'done':
          return const Color(0xFF059669);
        case 'cancelled':
          return const Color(0xFF4B5563);
        default:
          return const Color(0xFF2563EB);
      }
    }
    return column.lightBg;
  }

  Color _columnBorder() {
    if (isDark) {
      switch (column.id) {
        case 'in_progress':
          return const Color(0xFFF59E0B);
        case 'done':
          return const Color(0xFF10B981);
        case 'cancelled':
          return const Color(0xFF6B7280);
        default:
          return const Color(0xFF3B82F6);
      }
    }
    return column.lightBorder;
  }

  Color _columnTitleColor() {
    return isDark ? Colors.white : column.lightFg;
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (d) => d.data.isNotEmpty,
      onAcceptWithDetails: (d) => onAccept(d.data),
      builder: (context, candidate, rejected) {
        final highlight = candidate.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: width,
          constraints: const BoxConstraints(minHeight: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _columnBg(),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: highlight ? Theme.of(context).colorScheme.primary : _columnBorder(),
              width: highlight ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                column.label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: _columnTitleColor(),
                ),
              ),
              const SizedBox(height: 12),
              ...jobs.map(
                (job) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _KanbanJobCard(
                    job: job,
                    isDragging: draggingJobId == job.id,
                    customerLabel: customerLabel(job),
                    jobNum: jobNumber(job),
                    onOpenJob: () => onOpenJob(job),
                    onDragStarted: () => onDragStarted(job.id),
                    onDragEnded: onDragEnded,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _KanbanJobCard extends StatelessWidget {
  final dynamic job;
  final bool isDragging;
  final String customerLabel;
  final String jobNum;
  final VoidCallback onOpenJob;
  final VoidCallback onDragStarted;
  final VoidCallback onDragEnded;

  const _KanbanJobCard({
    required this.job,
    required this.isDragging,
    required this.customerLabel,
    required this.jobNum,
    required this.onOpenJob,
    required this.onDragStarted,
    required this.onDragEnded,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = Theme.of(context).cardColor;
    final borderColor = Theme.of(context).dividerColor;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Material(
        color: cardBg,
        borderRadius: BorderRadius.circular(8),
        elevation: isDragging ? 0 : 1,
        child: Opacity(
          opacity: isDragging ? 0.45 : 1,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Draggable<String>(
                  data: job.id,
                  dragAnchorStrategy: pointerDragAnchorStrategy,
                  onDragStarted: onDragStarted,
                  onDragEnd: (_) => onDragEnded(),
                  feedback: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 220,
                      child: _cardBody(context, dragging: true),
                    ),
                  ),
                  childWhenDragging: SizedBox(
                    width: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                      ),
                    ),
                  ),
                  child: Tooltip(
                    message: 'Drag to move',
                    child: MouseRegion(
                      cursor: SystemMouseCursors.grab,
                      child: Container(
                        width: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                        ),
                        child: Icon(
                          Icons.drag_indicator,
                          size: 18,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(child: _cardBody(context, dragging: false)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardBody(BuildContext context, {required bool dragging}) {
    final linkColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: dragging ? null : onOpenJob,
            child: Text(
              jobNum.isEmpty ? '—' : jobNum,
              style: TextStyle(fontWeight: FontWeight.w600, color: linkColor),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            customerLabel,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}
