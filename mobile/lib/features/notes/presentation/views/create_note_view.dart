import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../subjects/presentation/viewmodels/subject_viewmodel.dart';
import '../viewmodels/note_viewmodel.dart';

class CreateNoteView extends StatefulWidget {
  static const String routeName = '/create-note';

  const CreateNoteView({super.key});

  @override
  State<CreateNoteView> createState() => _CreateNoteViewState();
}

class _CreateNoteViewState extends State<CreateNoteView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagController = TextEditingController();

  String? _selectedSubjectId;
  bool _isShared = false;
  final List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubjectViewModel>().fetchSubjects();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag() {
    final text = _tagController.text.trim();
    if (text.isNotEmpty && !_tags.contains(text)) {
      setState(() {
        _tags.add(text);
        _tagController.clear();
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<NoteViewModel>();
    final success = await vm.createNote(
      subjectId: _selectedSubjectId,
      title: _titleController.text,
      content: _contentController.text,
      tags: _tags,
      isShared: _isShared,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note created successfully!')),
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
    final isSaving = context.watch<NoteViewModel>().isSaving;

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
          'Create Note',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: isSaving ? null : _handleSave,
              child: isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F5132),
                      ),
                    ),
            ),
          ),
        ],
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
                  // Title Input
                  TextFormField(
                    controller: _titleController,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                    decoration: _inputDecoration.copyWith(
                      hintText: 'Note Title (e.g. Data Structures Notes)',
                      hintStyle: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Enter a note title.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Subject Selector
                  DropdownButtonFormField<String>(
                    value: _selectedSubjectId,
                    dropdownColor: Colors.white,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                    ),
                    decoration: _inputDecoration.copyWith(
                      hintText: 'Select Subject (Optional)',
                      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                    ),
                    items: subjects.map((sub) {
                      return DropdownMenuItem(
                        value: sub.id,
                        child: Text('${sub.name} (${sub.code ?? ""})'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() => _selectedSubjectId = val);
                    },
                  ),
                  const SizedBox(height: 14),

                  // Share with classmates toggle
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Share with Community',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Allow peers to view this note in Shared tab',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: _isShared,
                          activeThumbColor: const Color(0xFF0F5132),
                          onChanged: (val) => setState(() => _isShared = val),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Tags input
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _tagController,
                          onSubmitted: (_) => _addTag(),
                          decoration: _inputDecoration.copyWith(
                            hintText: 'Add tag (e.g. Unit 1, Exam, Tree)',
                            hintStyle:
                                const TextStyle(color: Color(0xFF9CA3AF)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: Color(0xFF0F5132),
                          size: 32,
                        ),
                        onPressed: _addTag,
                      ),
                    ],
                  ),
                  if (_tags.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: _tags.map((tag) {
                        return Chip(
                          label: Text('#$tag'),
                          backgroundColor: const Color(0xFFEBF5E9),
                          labelStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F5132),
                          ),
                          onDeleted: () {
                            setState(() => _tags.remove(tag));
                          },
                          deleteIconColor: const Color(0xFF0F5132),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 14),

                  // Content Input
                  TextFormField(
                    controller: _contentController,
                    maxLines: 14,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                      height: 1.5,
                    ),
                    decoration: _inputDecoration.copyWith(
                      hintText: 'Write your revision notes here...',
                      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isSaving ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F5132),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Save Note',
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

