import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:campusflow/core/widgets/app_network_or_memory_image.dart';
import 'package:campusflow/features/subjects/presentation/viewmodels/subject_viewmodel.dart';
import 'package:campusflow/features/questions/presentation/viewmodels/question_viewmodel.dart';
import 'package:campusflow/features/questions/domain/models/question_model.dart';
import 'package:campusflow/core/widgets/category_bottom_sheet.dart';
import 'package:campusflow/features/subjects/presentation/widgets/add_edit_subject_dialog.dart';
import 'package:campusflow/app/theme/app_colors.dart';

class CreateQuestionView extends StatefulWidget {
  static const String routeName = '/create-question';

  final QuestionModel? initialQuestion;

  const CreateQuestionView({super.key, this.initialQuestion});

  @override
  State<CreateQuestionView> createState() => _CreateQuestionViewState();
}

class _CreateQuestionViewState extends State<CreateQuestionView> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  String? _selectedSubjectId;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.initialQuestion != null) {
      _questionController.text = widget.initialQuestion!.question;
      _answerController.text = widget.initialQuestion!.answer ?? '';
      _selectedSubjectId = widget.initialQuestion!.subjectId;
      _imageUrl = widget.initialQuestion!.imageUrl;
    }
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
    bool success;

    if (widget.initialQuestion != null) {
      success = await vm.updateQuestion(
        id: widget.initialQuestion!.id,
        subjectId: _selectedSubjectId,
        question: _questionController.text.trim(),
        answer: _answerController.text.trim(),
        imageUrl: _imageUrl,
      );
    } else {
      success = await vm.createQuestion(
        subjectId: _selectedSubjectId,
        question: _questionController.text.trim(),
        answer: _answerController.text.trim(),
        imageUrl: _imageUrl,
      );
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.initialQuestion != null
                ? 'Question updated successfully!'
                : 'Question saved successfully!',
          ),
          backgroundColor: const Color(0xFF0F5132),
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _pickImageFromGallery([BuildContext? bottomSheetContext]) async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        final base64String = base64Encode(bytes);
        final mimeType = pickedFile.mimeType ?? 'image/jpeg';
        setState(() {
          _imageUrl = 'data:$mimeType;base64,$base64String';
        });
        if (bottomSheetContext != null && bottomSheetContext.mounted) {
          Navigator.pop(bottomSheetContext);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImagePickerDialog() {
    final urlController = TextEditingController(
      text: (_imageUrl != null && !_imageUrl!.startsWith('data:image'))
          ? _imageUrl
          : '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Add Diagram or Image',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Browse your device gallery or paste an image link.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 18),

                // Browse Device Gallery Button
                ElevatedButton.icon(
                  onPressed: () => _pickImageFromGallery(ctx),
                  icon: const Icon(LucideIcons.images, size: 20),
                  label: const Text(
                    'Browse Device Gallery',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F5132),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'OR ENTER IMAGE URL',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: urlController,
                  autofocus: false,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
                  decoration: _inputDecoration.copyWith(
                    hintText: 'https://example.com/diagram.png',
                    prefixIcon: const Icon(
                      LucideIcons.link,
                      size: 18,
                      color: Color(0xFF9CA3AF),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        LucideIcons.clipboard,
                        size: 18,
                        color: Color(0xFF0F5132),
                      ),
                      tooltip: 'Paste from clipboard',
                      onPressed: () async {
                        final data = await Clipboard.getData('text/plain');
                        if (data?.text != null && data!.text!.isNotEmpty) {
                          urlController.text = data.text!.trim();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Sample Diagrams:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _sampleChip(
                      'Binary Tree',
                      'https://images.unsplash.com/photo-1516116211227-bbc00688fc00?w=600',
                      urlController,
                    ),
                    _sampleChip(
                      'ER Diagram',
                      'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=600',
                      urlController,
                    ),
                    _sampleChip(
                      'Logic Gate Circuit',
                      'https://images.unsplash.com/photo-1518770660439-4636190af475?w=600',
                      urlController,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (_imageUrl != null && _imageUrl!.isNotEmpty)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() => _imageUrl = null);
                            Navigator.pop(ctx);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Remove'),
                        ),
                      ),
                    if (_imageUrl != null && _imageUrl!.isNotEmpty)
                      const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          final text = urlController.text.trim();
                          setState(() {
                            _imageUrl = text.isEmpty ? null : text;
                          });
                          Navigator.pop(ctx);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0F5132),
                          side: const BorderSide(color: Color(0xFF0F5132)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Confirm URL'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sampleChip(String label, String url, TextEditingController controller) {
    return ActionChip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 11, color: Color(0xFF0F5132), fontWeight: FontWeight.w500),
      ),
      backgroundColor: const Color(0xFFEBF5E9),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onPressed: () {
        controller.text = url;
      },
    );
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
      backgroundColor: context.scaffoldBg,
      appBar: AppBar(
        backgroundColor: context.scaffoldBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, size: 20),
          color: context.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.initialQuestion != null ? 'Edit Question' : 'Create Question',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: context.textPrimary,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Category / Subject',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          final created =
                              await AddEditSubjectDialog.show(context);
                          if (created != null && mounted) {
                            setState(() {
                              _selectedSubjectId = created.id;
                            });
                          }
                        },
                        icon: const Icon(LucideIcons.plus, size: 14),
                        label: const Text(
                          'New Subject',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          foregroundColor: context.primaryAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final categoryNames = subjects.map((s) => s.name).toList();
                      if (!categoryNames.contains('Other')) categoryNames.add('Other');
                      const addNewLabel = '+ Add New Subject...';
                      if (!categoryNames.contains(addNewLabel)) {
                        categoryNames.add(addNewLabel);
                      }
                      final selectedName = subjects
                          .where((s) => s.id == _selectedSubjectId)
                          .map((s) => s.name)
                          .firstOrNull;
                      final chosen = await CategoryBottomSheet.show(
                        context,
                        categories: categoryNames,
                        initialSelected: selectedName,
                      );
                      if (chosen != null) {
                        if (chosen == addNewLabel) {
                          final created =
                              await AddEditSubjectDialog.show(context);
                          if (created != null && mounted) {
                            setState(() {
                              _selectedSubjectId = created.id;
                            });
                          }
                        } else {
                          final found =
                              subjects.where((s) => s.name == chosen).firstOrNull;
                          setState(() {
                            _selectedSubjectId = found?.id;
                          });
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: context.isDarkMode
                            ? const Color(0xFF262626)
                            : const Color(0xFFF3F4F6),
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
                                  ? context.textPrimary
                                  : context.textSecondary,
                            ),
                          ),
                          Icon(
                            LucideIcons.chevronDown,
                            color: context.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Add image optional card
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Image (Optional)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      if (_imageUrl != null && _imageUrl!.isNotEmpty)
                        TextButton.icon(
                          onPressed: () => setState(() => _imageUrl = null),
                          icon: const Icon(LucideIcons.trash2, size: 14, color: Colors.red),
                          label: const Text(
                            'Remove',
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _showImagePickerDialog,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: _imageUrl != null && _imageUrl!.isNotEmpty ? 160 : 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _imageUrl != null && _imageUrl!.isNotEmpty
                              ? const Color(0xFF0F5132)
                              : const Color(0xFFE5E7EB),
                          width: _imageUrl != null && _imageUrl!.isNotEmpty ? 1.5 : 1,
                        ),
                      ),
                      child: _imageUrl != null && _imageUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  AppNetworkOrMemoryImage(
                                    imageUrl: _imageUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.7),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(LucideIcons.edit2, size: 12, color: Colors.white),
                                          SizedBox(width: 4),
                                          Text(
                                            'Change',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    LucideIcons.images,
                                    size: 32,
                                    color: const Color(0xFF0F5132),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Browse Gallery or Paste URL',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF1F2937),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Tap to select a diagram or image',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
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

