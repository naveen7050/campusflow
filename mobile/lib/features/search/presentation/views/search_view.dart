import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campusflow/features/subjects/presentation/viewmodels/subject_viewmodel.dart';
import 'package:campusflow/features/subjects/presentation/views/subject_detail_view.dart';
import 'package:campusflow/features/notes/presentation/viewmodels/note_viewmodel.dart';
import 'package:campusflow/features/notes/presentation/views/notes_view.dart';
import 'package:campusflow/features/materials/presentation/viewmodels/material_viewmodel.dart';
import 'package:campusflow/features/materials/presentation/views/materials_view.dart';
import 'package:campusflow/features/questions/presentation/viewmodels/question_viewmodel.dart';
import 'package:campusflow/features/questions/presentation/views/questions_view.dart';
import 'package:campusflow/features/assignments/presentation/viewmodels/assignment_viewmodel.dart';
import 'package:campusflow/features/assignments/presentation/views/assignments_view.dart';

class SearchView extends StatefulWidget {
  static const String routeName = '/search';

  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = ['DSA', 'dbms', 'java'];
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubjectViewModel>().fetchSubjects();
      context.read<NoteViewModel>().fetchNotes();
      context.read<MaterialViewModel>().fetchMaterials();
      context.read<QuestionViewModel>().fetchQuestions();
      context.read<AssignmentViewModel>().fetchAssignments();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String val) {
    setState(() {
      _query = val.trim();
    });
  }

  void _applyRecentSearch(String term) {
    _searchController.text = term;
    _onSearch(term);
  }

  @override
  Widget build(BuildContext context) {
    final subjects = context.watch<SubjectViewModel>().subjects;
    final notes = context.watch<NoteViewModel>().notes;
    final materials = context.watch<MaterialViewModel>().materials;
    final questions = context.watch<QuestionViewModel>().questions;
    final assignments = context.watch<AssignmentViewModel>().assignments;

    final queryLower = _query.toLowerCase();

    final matchingNotes = _query.isEmpty
        ? []
        : notes
            .where((n) =>
                n.title.toLowerCase().contains(queryLower) ||
                n.content.toLowerCase().contains(queryLower))
            .toList();

    final matchingMaterials = _query.isEmpty
        ? []
        : materials
            .where((m) => m.title.toLowerCase().contains(queryLower))
            .toList();

    final matchingQuestions = _query.isEmpty
        ? []
        : questions
            .where((q) =>
                q.question.toLowerCase().contains(queryLower) ||
                (q.answer != null &&
                    q.answer!.toLowerCase().contains(queryLower)))
            .toList();

    final matchingAssignments = _query.isEmpty
        ? []
        : assignments
            .where((a) => a.title.toLowerCase().contains(queryLower))
            .toList();

    final hasResults = matchingNotes.isNotEmpty ||
        matchingMaterials.isNotEmpty ||
        matchingQuestions.isNotEmpty ||
        matchingAssignments.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          color: const Color(0xFF1F2937),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            onChanged: _onSearch,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1F2937),
            ),
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: const TextStyle(
                fontSize: 14,
                color: Color(0xFF9CA3AF),
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Color(0xFF9CA3AF),
                size: 20,
              ),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      color: const Color(0xFF9CA3AF),
                      onPressed: () {
                        _searchController.clear();
                        _onSearch('');
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: _query.isEmpty
                ? ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    children: [
                      // Recent Searches (Screen 17 Mockup)
                      const Text(
                        'Recent Searches',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        children: _recentSearches.map((term) {
                          return ActionChip(
                            label: Text(
                              term,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF4B5563),
                              ),
                            ),
                            backgroundColor: const Color(0xFFF3F4F6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                color: Color(0xFFE5E7EB),
                              ),
                            ),
                            onPressed: () => _applyRecentSearch(term),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Categories (Screen 17 Mockup)
                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (subjects.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'No categories created yet.',
                            style: TextStyle(color: Color(0xFF9CA3AF)),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: subjects.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final sub = subjects[index];
                            return _CategoryItem(
                              title: sub.name,
                              code: sub.code,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        SubjectDetailView(subject: sub),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                    ],
                  )
                : !hasResults
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: Color(0xFF9CA3AF),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No results found for "$_query"',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        children: [
                          if (matchingQuestions.isNotEmpty) ...[
                            _buildSectionHeader(
                              'Questions (${matchingQuestions.length})',
                            ),
                            for (final q in matchingQuestions)
                              _SearchResultTile(
                                icon: Icons.quiz_outlined,
                                iconColor: const Color(0xFF0F5132),
                                title: q.question,
                                subtitle: q.subjectName ?? 'Question Bank',
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  QuestionsView.routeName,
                                ),
                              ),
                            const SizedBox(height: 16),
                          ],
                          if (matchingNotes.isNotEmpty) ...[
                            _buildSectionHeader(
                              'Notes (${matchingNotes.length})',
                            ),
                            for (final n in matchingNotes)
                              _SearchResultTile(
                                icon: Icons.notes_outlined,
                                iconColor: const Color(0xFF2E7D32),
                                title: n.title,
                                subtitle: n.subjectName ?? 'Notes',
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  NotesView.routeName,
                                ),
                              ),
                            const SizedBox(height: 16),
                          ],
                          if (matchingMaterials.isNotEmpty) ...[
                            _buildSectionHeader(
                              'Study Materials (${matchingMaterials.length})',
                            ),
                            for (final m in matchingMaterials)
                              _SearchResultTile(
                                icon: Icons.folder_outlined,
                                iconColor: const Color(0xFF1E3A8A),
                                title: m.title,
                                subtitle: m.subjectName ?? 'Material',
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  MaterialsView.routeName,
                                ),
                              ),
                            const SizedBox(height: 16),
                          ],
                          if (matchingAssignments.isNotEmpty) ...[
                            _buildSectionHeader(
                              'Assignments (${matchingAssignments.length})',
                            ),
                            for (final a in matchingAssignments)
                              _SearchResultTile(
                                icon: Icons.assignment_outlined,
                                iconColor: const Color(0xFFD97706),
                                title: a.title,
                                subtitle: a.subjectName ?? 'Assignment',
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AssignmentsView.routeName,
                                ),
                              ),
                          ],
                        ],
                      ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF6B7280),
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String title;
  final String? code;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.title,
    this.code,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFEBF5E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                size: 18,
                color: Color(0xFF0F5132),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            if (code != null) ...[
              Text(
                code!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SearchResultTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          size: 18,
          color: Color(0xFF9CA3AF),
        ),
        onTap: onTap,
      ),
    );
  }
}

