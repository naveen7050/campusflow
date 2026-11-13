import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campusflow/features/questions/domain/models/question_model.dart';
import 'package:campusflow/features/questions/presentation/viewmodels/question_viewmodel.dart';
import 'create_question_view.dart';

class QuestionsView extends StatefulWidget {
  static const String routeName = '/questions';

  final String? subjectId;
  final String? subjectName;

  const QuestionsView({super.key, this.subjectId, this.subjectName});

  @override
  State<QuestionsView> createState() => _QuestionsViewState();
}

class _QuestionsViewState extends State<QuestionsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<QuestionViewModel>();
      if (widget.subjectId != null) {
        vm.setSubjectFilter(widget.subjectId);
      } else {
        vm.fetchQuestions();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuestionViewModel>();
    final questions = vm.filteredQuestions;

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
              ? '${widget.subjectName} Questions'
              : 'Question Bank',
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
                    // Search & Tabs
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: Column(
                        children: [
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
                                hintText: 'Search questions & answers...',
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
                          Row(
                            children: [
                              _FilterChipTab(
                                label: 'All',
                                isSelected: vm.selectedFilter == 'all',
                                onTap: () => vm.setFilter('all'),
                              ),
                              const SizedBox(width: 8),
                              _FilterChipTab(
                                label: 'Starred',
                                isSelected: vm.selectedFilter == 'starred',
                                onTap: () => vm.setFilter('starred'),
                              ),
                              const SizedBox(width: 8),
                              _FilterChipTab(
                                label: 'Shared',
                                isSelected: vm.selectedFilter == 'shared',
                                onTap: () => vm.setFilter('shared'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // List of Questions
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
                                        onPressed: vm.fetchQuestions,
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
                              : questions.isEmpty
                                  ? _buildEmptyState(context)
                                  : RefreshIndicator(
                                      onRefresh: vm.fetchQuestions,
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
                                                childAspectRatio: 1.8,
                                              ),
                                              itemCount: questions.length,
                                              itemBuilder: (context, index) {
                                                return _QuestionCard(
                                                  question: questions[index],
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
                                              itemCount: questions.length,
                                              separatorBuilder: (_, __) =>
                                                  const SizedBox(height: 12),
                                              itemBuilder: (context, index) {
                                                return _QuestionCard(
                                                  question: questions[index],
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
          Navigator.pushNamed(context, CreateQuestionView.routeName);
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
                Icons.quiz_outlined,
                size: 40,
                color: Color(0xFF0F5132),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No questions yet!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add past exam questions and key concepts to practice.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, CreateQuestionView.routeName);
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Question'),
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

class _FilterChipTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipTab({
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

class _QuestionCard extends StatefulWidget {
  final QuestionModel question;

  const _QuestionCard({required this.question});

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard> {
  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<QuestionViewModel>();
    final q = widget.question;

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with Subject chip and Star icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (q.subjectName != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF5E9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    q.subjectName!,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F5132),
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      q.isShared
                          ? Icons.share_rounded
                          : Icons.share_outlined,
                      color: q.isShared
                          ? const Color(0xFF0F5132)
                          : const Color(0xFF9CA3AF),
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: q.isShared ? 'Shared with peers' : 'Share with peers',
                    onPressed: () async {
                      final ok = await vm.toggleShare(q);
                      if (ok && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              q.isShared
                                  ? 'Question unshared'
                                  : 'Question shared with campus peers!',
                            ),
                            backgroundColor: const Color(0xFF0F5132),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      q.isStarred
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color:
                          q.isStarred ? Colors.amber : const Color(0xFF9CA3AF),
                      size: 22,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => vm.toggleStar(q.id),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Question Text
          Text(
            q.question,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 10),

          // Answer Section Toggle
          if (q.answer != null && q.answer!.isNotEmpty) ...[
            InkWell(
              onTap: () => setState(() => _showAnswer = !_showAnswer),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      _showAnswer
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18,
                      color: const Color(0xFF0F5132),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _showAnswer ? 'Hide Answer' : 'Show Answer',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F5132),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_showAnswer) ...[
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Text(
                  q.answer!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4B5563),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
