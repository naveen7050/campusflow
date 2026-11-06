import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/subject_viewmodel.dart';
import '../widgets/add_edit_subject_dialog.dart';
import '../widgets/subject_card.dart';
import 'subject_detail_view.dart';

class SubjectsView extends StatefulWidget {
  static const String routeName = '/subjects';

  const SubjectsView({super.key});

  @override
  State<SubjectsView> createState() => _SubjectsViewState();
}

class _SubjectsViewState extends State<SubjectsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubjectViewModel>().fetchSubjects();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddSubject() {
    AddEditSubjectDialog.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SubjectViewModel>();
    final subjects = viewModel.filteredSubjects;

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
        title: const Text(
          'Subjects',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            color: const Color(0xFF0F5132),
            tooltip: 'Add Subject',
            onPressed: _openAddSubject,
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF0F5132),
          onRefresh: () => viewModel.fetchSubjects(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 1024;
              final isTablet = constraints.maxWidth >= 600 && !isDesktop;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    children: [
                      // Search and Filter Section
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
                                onChanged: (q) => viewModel.setSearchQuery(q),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1F2937),
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search subjects, code, or department...',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF9CA3AF),
                                    fontSize: 13,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Color(0xFF9CA3AF),
                                    size: 20,
                                  ),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear, size: 18),
                                          onPressed: () {
                                            _searchController.clear();
                                            viewModel.setSearchQuery('');
                                          },
                                        )
                                      : null,
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Semester Filter Chips
                            SizedBox(
                              height: 36,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  _FilterChip(
                                    label: 'All',
                                    isSelected: viewModel.selectedSemester == null,
                                    onTap: () => viewModel.setSemesterFilter(null),
                                  ),
                                  ...List.generate(8, (i) {
                                    final sem = i + 1;
                                    return _FilterChip(
                                      label: 'Sem $sem',
                                      isSelected:
                                          viewModel.selectedSemester == sem,
                                      onTap: () =>
                                          viewModel.setSemesterFilter(sem),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Content Section
                      Expanded(
                        child: _buildBody(
                          viewModel,
                          subjects,
                          isTablet: isTablet,
                          isDesktop: isDesktop,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddSubject,
        backgroundColor: const Color(0xFF0F5132),
        foregroundColor: Colors.white,
        elevation: 3,
        tooltip: 'Add Subject',
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildBody(
    SubjectViewModel viewModel,
    List subjects, {
    required bool isTablet,
    required bool isDesktop,
  }) {
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF0F5132)),
      );
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Color(0xFFEF4444),
              ),
              const SizedBox(height: 12),
              Text(
                'Could not load subjects',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                viewModel.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => viewModel.fetchSubjects(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5132),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (subjects.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF5E9),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  size: 56,
                  color: Color(0xFF0F5132),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'No subjects yet!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Add your semester subjects to start organizing notes, question papers, and study material.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _openAddSubject,
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Add Subject'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5132),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Adaptive layout: Grid on tablet/desktop, ListView on phone
    if (isDesktop || isTablet) {
      final crossAxisCount = isDesktop ? 3 : 2;
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.8,
        ),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          return SubjectCard(
            subject: subject,
            onTap: () => _openDetail(subject),
          );
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];
        return SubjectCard(
          subject: subject,
          onTap: () => _openDetail(subject),
        );
      },
    );
  }

  void _openDetail(dynamic subject) {
    Navigator.pushNamed(
      context,
      SubjectDetailView.routeName,
      arguments: subject,
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F5132) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF4B5563),
            ),
          ),
        ),
      ),
    );
  }
}

