import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campusflow/features/subjects/presentation/viewmodels/subject_viewmodel.dart';
import 'package:campusflow/features/questions/presentation/viewmodels/question_viewmodel.dart';
import 'package:campusflow/core/widgets/category_bottom_sheet.dart';

class CreateQuestionView extends StatefulWidget {
  static const String routeName = '/create-question';

  const CreateQuestionView({super.key});

  @override
  State<CreateQuestionView> createState() => _CreateQuestionViewState();
}

class _CreateQuestionViewState extends State<CreateQuestionView> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  String? _selectedSubjectId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubjectViewModel>().fetchSubjects();
    });
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _saveQuestion() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<QuestionViewModel>();
    final success = await vm.createQuestion(
      subjectId: _selectedSubjectId,
      question: _questionController.text.trim(),
      answer: _answerController.text.trim(),
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Question saved successfully!'),
          backgroundColor: Color(0xFF0F5132),
        ),
      );
      Navigator.pop(context);
    }
  }

  static const _inputDecoration = InputDecoration(
    filled: true,
    fillColor: Color(0xFFF3F4F6),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Color(0xFF0F5132), width: 1.5),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );

  @override
  Widget build(BuildContext context) {
    final subjects = context.watch<SubjectViewModel>().subjects;

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
        title: const Text(
          'Create Question',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Question label & field
                  const Text(
                    'Question',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _questionController,
                    maxLines: 4,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                    ),
                    decoration: _inputDecoration.copyWith(
                      hintText: 'Enter your question here...',
                      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Enter a question.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  // Answer label & field
                  const Text(
                    'Answer (Optional)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _answerController,
                    maxLines: 4,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                    ),
                    decoration: _inputDecoration.copyWith(
                      hintText: 'Enter answer here...',
                      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Category selector (Screen 20 Bottom Sheet Integration)
                  const Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final categoryNames = subjects.map((s) => s.name).toList();
                      if (!categoryNames.contains('Other')) categoryNames.add('Other');
                      final selectedName = subjects
                          .where((s) => s.id == _selectedSubjectId)
                          .map((s) => s.name)
                          .firstOrNull;
                      final chosen = await CategoryBottomSheet.show(
                        context,
                        categories: categoryNames.isNotEmpty
                            ? categoryNames
                            : ['DSA', 'Database', 'Web Development', 'Java', 'Android', 'Other'],
                        initialSelected: selectedName,
                      );
                      if (chosen != null) {
                        final found =
                            subjects.where((s) => s.name == chosen).firstOrNull;
                        setState(() {
                          _selectedSubjectId = found?.id;
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            subjects
                                    .where((s) => s.id == _selectedSubjectId)
                                    .map((s) => s.name)
                                    .firstOrNull ??
                                'Select category',
                            style: TextStyle(
                              fontSize: 14,
                              color: _selectedSubjectId != null
                                  ? const Color(0xFF1F2937)
                                  : const Color(0xFF9CA3AF),
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF9CA3AF),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Add image optional card
                  const Text(
                    'Add Image (Optional)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 32,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tap to upload diagram or formula image',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: context.watch<QuestionViewModel>().isSaving
                          ? null
                          : _saveQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F5132),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: context.watch<QuestionViewModel>().isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
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

