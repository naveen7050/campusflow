import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campusflow/features/assignments/domain/models/assignment_model.dart';
import 'package:campusflow/features/assignments/presentation/viewmodels/assignment_viewmodel.dart';
import 'package:campusflow/features/assignments/presentation/widgets/add_assignment_dialog.dart';

class AssignmentsView extends StatefulWidget {
  static const String routeName = '/assignments';

  final String? subjectId;
  final String? subjectName;

  const AssignmentsView({super.key, this.subjectId, this.subjectName});

  @override
  State<AssignmentsView> createState() => _AssignmentsViewState();
}

class _AssignmentsViewState extends State<AssignmentsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<AssignmentViewModel>();
      if (widget.subjectId != null) {
        vm.setSubjectFilter(widget.subjectId);
      } else {
        vm.fetchAssignments();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatDueDate(DateTime? dt) {
    if (dt == null) return 'No due date';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return 'Due: ${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AssignmentViewModel>();
    final assignments = vm.filteredAssignments;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                color: const Color(0xFF1F2937),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          widget.subjectName != null
              ? '${widget.subjectName} Assignments'
              : 'Assignments',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 1024;
            final isTablet = constraints.maxWidth >= 600 && !isDesktop;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  children: [
                    // Search & Filter Tabs
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: Column(
                        children: [
                          // Search bar
                          Container(
                            height: 46,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: vm.setSearchQuery,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1F2937),
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Search assignments...',
                                hintStyle: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF9CA3AF),
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Color(0xFF9CA3AF),
                                  size: 20,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Tabs: All, Upcoming, Completed
                          Row(
                            children: [
                              _FilterTab(
                                label: 'All',
                                isSelected: vm.selectedFilter == 'all',
                                onTap: () => vm.setFilter('all'),
                              ),
                              const SizedBox(width: 8),
                              _FilterTab(
                                label: 'Upcoming',
                                isSelected: vm.selectedFilter == 'upcoming',
                                onTap: () => vm.setFilter('upcoming'),
                              ),
                              const SizedBox(width: 8),
                              _FilterTab(
                                label: 'Completed',
                                isSelected: vm.selectedFilter == 'completed',
                                onTap: () => vm.setFilter('completed'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // List view
                    Expanded(
                      child: vm.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF0F5132),
                              ),
                            )
                          : vm.errorMessage != null
                              ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        size: 48,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        vm.errorMessage!,
                                        style: const TextStyle(
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ElevatedButton(
                                        onPressed: vm.fetchAssignments,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF0F5132),
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                )
                              : assignments.isEmpty
                                  ? _buildEmptyState(context)
                                  : RefreshIndicator(
                                      onRefresh: vm.fetchAssignments,
                                      color: const Color(0xFF0F5132),
                                      child: isDesktop || isTablet
                                          ? GridView.builder(
                                              padding: const EdgeInsets.all(16),
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount:
                                                    isDesktop ? 3 : 2,
                                                crossAxisSpacing: 16,
                                                mainAxisSpacing: 16,
                                                childAspectRatio: 2.2,
                                              ),
                                              itemCount: assignments.length,
                                              itemBuilder: (context, index) {
                                                return _AssignmentCard(
                                                  assignment:
                                                      assignments[index],
                                                  formattedDueDate:
                                                      _formatDueDate(
                                                    assignments[index].dueDate,
                                                  ),
                                                );
                                              },
                                            )
                                          : ListView.separated(
                                              padding: const EdgeInsets.fromLTRB(
                                                16,
                                                4,
                                                16,
                                                80,
                                              ),
                                              itemCount: assignments.length,
                                              separatorBuilder: (_, __) =>
                                                  const SizedBox(height: 12),
                                              itemBuilder: (context, index) {
                                                return _AssignmentCard(
                                                  assignment:
                                                      assignments[index],
                                                  formattedDueDate:
                                                      _formatDueDate(
                                                    assignments[index].dueDate,
                                                  ),
                                                );
                                              },
                                            ),
                                    ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddAssignmentDialog.show(
            context,
            defaultSubjectId: widget.subjectId,
          );
        },
        backgroundColor: const Color(0xFF0F5132),
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFEBF5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_outlined,
                size: 40,
                color: Color(0xFF0F5132),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No assignments yet!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Track upcoming homework and project submissions easily.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                AddAssignmentDialog.show(
                  context,
                  defaultSubjectId: widget.subjectId,
                );
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Assignment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F5132),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F5132) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF4B5563),
          ),
        ),
      ),
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  final AssignmentModel assignment;
  final String formattedDueDate;

  const _AssignmentCard({
    required this.assignment,
    required this.formattedDueDate,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.read<AssignmentViewModel>();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.assignment_outlined,
              color: Color(0xFFD97706),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assignment.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  formattedDueDate,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
                if (assignment.description != null &&
                    assignment.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    assignment.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
                const SizedBox(height: 8),

                // Status Pill (Matches Screen 12 mockup)
                InkWell(
                  onTap: () => vm.toggleAssignment(assignment.id),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: assignment.isSubmitted
                          ? const Color(0xFFEBF5E9)
                          : const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          assignment.isSubmitted
                              ? Icons.check
                              : Icons.close_rounded,
                          size: 13,
                          color: assignment.isSubmitted
                              ? const Color(0xFF0F5132)
                              : const Color(0xFFDC2626),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          assignment.isSubmitted ? 'Submitted' : 'Not submitted',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: assignment.isSubmitted
                                ? const Color(0xFF0F5132)
                                : const Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Actions Menu
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              size: 20,
              color: Color(0xFF9CA3AF),
            ),
            padding: EdgeInsets.zero,
            onSelected: (val) {
              if (val == 'toggle') {
                vm.toggleAssignment(assignment.id);
              } else if (val == 'edit') {
                AddAssignmentDialog.show(
                  context,
                  initialAssignment: assignment,
                );
              } else if (val == 'delete') {
                vm.deleteAssignment(assignment.id);
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'toggle',
                child: Text(
                  assignment.isSubmitted
                      ? 'Mark Not Submitted'
                      : 'Mark Submitted',
                ),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

