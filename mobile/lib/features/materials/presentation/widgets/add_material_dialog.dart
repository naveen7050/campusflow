import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../subjects/presentation/viewmodels/subject_viewmodel.dart';
import '../viewmodels/material_viewmodel.dart';

class AddMaterialDialog extends StatefulWidget {
  final String? initialSubjectId;

  const AddMaterialDialog({super.key, this.initialSubjectId});

  static Future<bool?> show(BuildContext context, {String? initialSubjectId}) {
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
            child: AddMaterialDialog(initialSubjectId: initialSubjectId),
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
          child: AddMaterialDialog(initialSubjectId: initialSubjectId),
        ),
      );
    }
  }

  @override
  State<AddMaterialDialog> createState() => _AddMaterialDialogState();
}

class _AddMaterialDialogState extends State<AddMaterialDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();

  String? _selectedSubjectId;
  String _selectedFileType = 'PDF';
  String _selectedFileSize = '1.5 MB';
  bool _isShared = false;

  final List<String> _fileTypes = const ['PDF', 'DOCX', 'PPT', 'Link'];

  @override
  void initState() {
    super.initState();
    _selectedSubjectId = widget.initialSubjectId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubjectViewModel>().fetchSubjects();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<MaterialViewModel>();
    final success = await vm.createMaterial(
      subjectId: _selectedSubjectId,
      title: _titleController.text,
      fileUrl: _urlController.text.isEmpty ? null : _urlController.text,
      fileType: _selectedFileType,
      fileSize: _selectedFileSize,
      isShared: _isShared,
    );

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
    final subjects = context.watch<SubjectViewModel>().subjects;
    final isSaving = context.watch<MaterialViewModel>().isSaving;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upload Study Material',
                  style: TextStyle(
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

            // Title
            TextFormField(
              controller: _titleController,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
              decoration: _inputDecoration.copyWith(
                hintText: 'Document Title (e.g. OOP PPT or DBMS Notes)',
                hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Enter material title.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Subject Selector
            DropdownButtonFormField<String>(
              value: _selectedSubjectId,
              dropdownColor: Colors.white,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
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
              onChanged: (val) => setState(() => _selectedSubjectId = val),
            ),
            const SizedBox(height: 12),

            // File Type Selector Chips
            const Text(
              'File Format',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4B5563),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: _fileTypes.map((type) {
                final isSelected = _selectedFileType == type;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFileType = type),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF0F5132)
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                            isSelected ? Colors.white : const Color(0xFF4B5563),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            // Document Link / URL
            TextFormField(
              controller: _urlController,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
              decoration: _inputDecoration.copyWith(
                hintText: 'File URL or Cloud Drive Link (Optional)',
                hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              ),
            ),
            const SizedBox(height: 14),

            // Share Toggle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Share with Classmates',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  Switch(
                    value: _isShared,
                    activeThumbColor: const Color(0xFF0F5132),
                    onChanged: (val) => setState(() => _isShared = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

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
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Upload Material',
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
    );
  }
}

