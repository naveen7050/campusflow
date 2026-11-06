import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/subject_model.dart';
import '../viewmodels/subject_viewmodel.dart';

class AddEditSubjectDialog extends StatefulWidget {
  final SubjectModel? subject;

  const AddEditSubjectDialog({super.key, this.subject});

  static Future<bool?> show(BuildContext context, {SubjectModel? subject}) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    if (isTablet) {
      return showDialog<bool>(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: AddEditSubjectDialog(subject: subject),
          ),
        ),
      );
    } else {
      return showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddEditSubjectDialog(subject: subject),
        ),
      );
    }
  }

  @override
  State<AddEditSubjectDialog> createState() => _AddEditSubjectDialogState();
}

class _AddEditSubjectDialogState extends State<AddEditSubjectDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _codeController;
  late TextEditingController _departmentController;
  late TextEditingController _descriptionController;

  int? _selectedSemester;
  late String _selectedColor;
  late String _selectedIcon;

  final List<String> _colors = const [
    '#0F5132', // CampusFlow Primary
    '#2E7D32', // Secondary Green
    '#1E3A8A', // Blue
    '#0D9488', // Teal
    '#D97706', // Amber
    '#7C3AED', // Purple
  ];

  final List<Map<String, dynamic>> _icons = const [
    {'name': 'menu_book', 'icon': Icons.menu_book_rounded},
    {'name': 'code', 'icon': Icons.code_rounded},
    {'name': 'database', 'icon': Icons.storage_rounded},
    {'name': 'web', 'icon': Icons.language_rounded},
    {'name': 'android', 'icon': Icons.android_rounded},
    {'name': 'calculate', 'icon': Icons.calculate_rounded},
  ];

  @override
  void initState() {
    super.initState();
    final s = widget.subject;
    _nameController = TextEditingController(text: s?.name ?? '');
    _codeController = TextEditingController(text: s?.code ?? '');
    _departmentController = TextEditingController(text: s?.department ?? '');
    _descriptionController = TextEditingController(text: s?.description ?? '');
    _selectedSemester = s?.semester ?? 1;
    _selectedColor = s?.color ?? '#0F5132';
    _selectedIcon = s?.icon ?? 'menu_book';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _departmentController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<SubjectViewModel>();
    bool success;

    if (widget.subject == null) {
      success = await vm.createSubject(
        name: _nameController.text,
        code: _codeController.text.isEmpty ? null : _codeController.text,
        description:
            _descriptionController.text.isEmpty ? null : _descriptionController.text,
        semester: _selectedSemester,
        department:
            _departmentController.text.isEmpty ? null : _departmentController.text,
        color: _selectedColor,
        icon: _selectedIcon,
      );
    } else {
      success = await vm.updateSubject(
        id: widget.subject!.id,
        name: _nameController.text,
        code: _codeController.text.isEmpty ? null : _codeController.text,
        description:
            _descriptionController.text.isEmpty ? null : _descriptionController.text,
        semester: _selectedSemester,
        department:
            _departmentController.text.isEmpty ? null : _departmentController.text,
        color: _selectedColor,
        icon: _selectedIcon,
      );
    }

    if (success && mounted) {
      Navigator.pop(context, true);
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
    final isEditing = widget.subject != null;
    final isSaving = context.watch<SubjectViewModel>().isSaving;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar for bottom sheet
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? 'Edit Subject' : 'Add Subject',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                    letterSpacing: -0.3,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Subject Name
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
              decoration: _inputDecoration.copyWith(
                hintText: 'Subject Name (e.g. Data Structures)',
                hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Enter subject name.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Code & Semester Row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _codeController,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
                    decoration: _inputDecoration.copyWith(
                      hintText: 'Code (e.g. CS201)',
                      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _selectedSemester,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
                    dropdownColor: Colors.white,
                    decoration: _inputDecoration.copyWith(
                      hintText: 'Semester',
                      hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                    ),
                    items: List.generate(8, (i) => i + 1)
                        .map((sem) => DropdownMenuItem(
                              value: sem,
                              child: Text('Sem $sem'),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() => _selectedSemester = val);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Department
            TextFormField(
              controller: _departmentController,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
              decoration: _inputDecoration.copyWith(
                hintText: 'Department (e.g. Computer Science)',
                hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              ),
            ),
            const SizedBox(height: 12),

            // Description
            TextFormField(
              controller: _descriptionController,
              maxLines: 2,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
              decoration: _inputDecoration.copyWith(
                hintText: 'Description or Syllabus Notes (Optional)',
                hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              ),
            ),
            const SizedBox(height: 16),

            // Icon Selection
            const Text(
              'Select Icon',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4B5563),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _icons.map((item) {
                final isSelected = _selectedIcon == item['name'];
                return InkWell(
                  onTap: () => setState(() => _selectedIcon = item['name']),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFEBF5E9)
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF0F5132)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      size: 22,
                      color: isSelected
                          ? const Color(0xFF0F5132)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Color Selection
            const Text(
              'Select Accent Color',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4B5563),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: _colors.map((hex) {
                final isSelected = _selectedColor == hex;
                final colorVal = Color(
                  int.parse('FF${hex.replaceAll('#', '')}', radix: 16),
                );
                return InkWell(
                  onTap: () => setState(() => _selectedColor = hex),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colorVal,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: colorVal.withValues(alpha: 0.4),
                                blurRadius: 6,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: isSaving ? null : _submit,
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
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        isEditing ? 'Save Changes' : 'Create Subject',
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
    );
  }
}

