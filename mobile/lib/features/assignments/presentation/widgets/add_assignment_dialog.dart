import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campusflow/features/subjects/presentation/viewmodels/subject_viewmodel.dart';
import 'package:campusflow/features/assignments/domain/models/assignment_model.dart';
import 'package:campusflow/features/assignments/presentation/viewmodels/assignment_viewmodel.dart';

class AddAssignmentDialog extends StatefulWidget {
  final AssignmentModel? initialAssignment;
  final String? defaultSubjectId;

  const AddAssignmentDialog({
    super.key,
    this.initialAssignment,
    this.defaultSubjectId,
  });

  static Future<void> show(
    BuildContext context, {
    AssignmentModel? initialAssignment,
    String? defaultSubjectId,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddAssignmentDialog(
        initialAssignment: initialAssignment,
        defaultSubjectId: defaultSubjectId,
      ),
    );
  }

  @override
  State<AddAssignmentDialog> createState() => _AddAssignmentDialogState();
}

class _AddAssignmentDialogState extends State<AddAssignmentDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  String? _selectedSubjectId;
  DateTime? _dueDate;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    final init = widget.initialAssignment;
    _titleController = TextEditingController(text: init?.title ?? '');
    _descController = TextEditingController(text: init?.description ?? '');
    _selectedSubjectId = init?.subjectId ?? widget.defaultSubjectId;
    _dueDate = init?.dueDate ?? DateTime.now().add(const Duration(days: 7));
    _isSubmitted = init?.isSubmitted ?? false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubjectViewModel>().fetchSubjects();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0F5132),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1F2937),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<AssignmentViewModel>();
    bool success = false;

    if (widget.initialAssignment != null) {
      success = await vm.updateAssignment(
        id: widget.initialAssignment!.id,
        subjectId: _selectedSubjectId,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        dueDate: _dueDate,
        isSubmitted: _isSubmitted,
      );
    } else {
      success = await vm.createAssignment(
        subjectId: _selectedSubjectId,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        dueDate: _dueDate,
        isSubmitted: _isSubmitted,
      );
    }

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.initialAssignment != null
                ? 'Assignment updated successfully!'
                : 'Assignment added successfully!',
          ),
          backgroundColor: const Color(0xFF0F5132),
        ),
      );
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
    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  );

  @override
  Widget build(BuildContext context) {
    final subjects = context.watch<SubjectViewModel>().subjects;
    final isSaving = context.watch<AssignmentViewModel>().isSaving;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top handle
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

                // Title
                Text(
                  widget.initialAssignment != null
                      ? 'Edit Assignment'
                      : 'Add Assignment',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 16),

                // Title Field
                const Text(
                  'Title',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _titleController,
                  style: const TextStyle(fontSize: 14),
                  decoration: _inputDecoration.copyWith(
                    hintText: 'e.g., DBMS Assignment',
                    hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Enter an assignment title.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Subject Selector
                const Text(
                  'Subject',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: _selectedSubjectId,
                  dropdownColor: Colors.white,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1F2937),
                  ),
                  decoration: _inputDecoration.copyWith(
                    hintText: 'Select subject',
                    hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                  ),
                  items: subjects.map((sub) {
                    return DropdownMenuItem(
                      value: sub.id,
                      child: Text(sub.name),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedSubjectId = val),
                ),
                const SizedBox(height: 14),

                // Due Date selector
                const Text(
                  'Due Date',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _dueDate != null
                              ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                              : 'Select due date',
                          style: TextStyle(
                            fontSize: 14,
                            color: _dueDate != null
                                ? const Color(0xFF1F2937)
                                : const Color(0xFF9CA3AF),
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: Color(0xFF0F5132),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Description
                const Text(
                  'Description (Optional)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _descController,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 14),
                  decoration: _inputDecoration.copyWith(
                    hintText: 'Add instructions, guidelines or requirements',
                    hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                  ),
                ),
                const SizedBox(height: 14),

                // Submission toggle
                Row(
                  children: [
                    Checkbox(
                      value: _isSubmitted,
                      activeColor: const Color(0xFF0F5132),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (val) =>
                          setState(() => _isSubmitted = val ?? false),
                    ),
                    const Text(
                      'Mark as already submitted',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Save button
                SizedBox(
                  height: 48,
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
                        : Text(
                            widget.initialAssignment != null
                                ? 'Update Assignment'
                                : 'Save Assignment',
                            style: const TextStyle(
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
    );
  }
}

