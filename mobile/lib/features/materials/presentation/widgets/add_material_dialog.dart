import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:campusflow/features/subjects/presentation/viewmodels/subject_viewmodel.dart';
import 'package:campusflow/features/subjects/presentation/widgets/add_edit_subject_dialog.dart';
import 'package:campusflow/features/materials/presentation/viewmodels/material_viewmodel.dart';
import 'package:campusflow/features/materials/domain/models/material_model.dart';
import 'package:campusflow/app/theme/app_colors.dart';

class AddMaterialDialog extends StatefulWidget {
  final String? initialSubjectId;
  final MaterialModel? initialMaterial;

  const AddMaterialDialog({
    super.key,
    this.initialSubjectId,
    this.initialMaterial,
  });

  static Future<bool?> show(
    BuildContext context, {
    String? initialSubjectId,
    MaterialModel? initialMaterial,
  }) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    if (isTablet) {
      return showDialog<bool>(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: context.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: AddMaterialDialog(
              initialSubjectId: initialSubjectId,
              initialMaterial: initialMaterial,
            ),
          ),
        ),
      );
    } else {
      return showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: context.cardBg,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddMaterialDialog(
            initialSubjectId: initialSubjectId,
            initialMaterial: initialMaterial,
          ),
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
  String? _pickedFileName;
  String? _pickedFilePath;

  final List<String> _fileTypes = const ['PDF', 'DOCX', 'PPT', 'Link'];

  @override
  void initState() {
    super.initState();
    if (widget.initialMaterial != null) {
      _titleController.text = widget.initialMaterial!.title;
      _urlController.text = widget.initialMaterial!.fileUrl ?? '';
      _selectedSubjectId = widget.initialMaterial!.subjectId;
      _selectedFileType = widget.initialMaterial!.fileType;
      _selectedFileSize = widget.initialMaterial!.fileSize;
      _isShared = widget.initialMaterial!.isShared;
      if (widget.initialMaterial!.fileUrl != null &&
          !widget.initialMaterial!.fileUrl!.startsWith('http')) {
        _pickedFilePath = widget.initialMaterial!.fileUrl;
        _pickedFileName = widget.initialMaterial!.fileUrl!.split(RegExp(r'[\\/]')).last;
      }
    } else {
      _selectedSubjectId = widget.initialSubjectId;
    }
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

  Future<void> _pickFile() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);

      if (picked != null) {
        final path = picked.path;
        final name = picked.name;
        final sizeBytes = await picked.length();
        final sizeInMb = (sizeBytes / (1024 * 1024)).toStringAsFixed(1);

        setState(() {
          _pickedFilePath = path;
          _pickedFileName = name;
          _selectedFileSize = '$sizeInMb MB';
          _urlController.text = path;

          final ext = name.split('.').last.toLowerCase();
          if (ext == 'pdf') {
            _selectedFileType = 'PDF';
          } else if (ext == 'docx' || ext == 'doc') {
            _selectedFileType = 'DOCX';
          } else if (ext == 'ppt' || ext == 'pptx') {
            _selectedFileType = 'PPT';
          }

          if (_titleController.text.trim().isEmpty) {
            final baseName = name.replaceAll(RegExp(r'\.[^.]+$'), '');
            _titleController.text = baseName;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to select file: $e')),
        );
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<MaterialViewModel>();
    bool success;

    final finalFileUrl = _pickedFilePath ??
        (_urlController.text.trim().isEmpty ? null : _urlController.text.trim());

    if (widget.initialMaterial != null) {
      success = await vm.updateMaterial(
        id: widget.initialMaterial!.id,
        subjectId: _selectedSubjectId,
        title: _titleController.text,
        fileUrl: finalFileUrl,
        fileType: _selectedFileType,
        fileSize: _selectedFileSize,
        isShared: _isShared,
      );
    } else {
      success = await vm.createMaterial(
        subjectId: _selectedSubjectId,
        title: _titleController.text,
        fileUrl: finalFileUrl,
        fileType: _selectedFileType,
        fileSize: _selectedFileSize,
        isShared: _isShared,
      );
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.initialMaterial != null
                ? 'Material updated successfully!'
                : 'Material added successfully!',
          ),
        ),
      );
      Navigator.pop(context, true);
    }
  }

  InputDecoration _inputDeco(BuildContext context, String hint) {
    return InputDecoration(
      filled: true,
      fillColor: context.isDarkMode
          ? const Color(0xFF262626)
          : const Color(0xFFF3F4F6),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: context.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: context.primaryAccent, width: 1.5),
      ),
      hintText: hint,
      hintStyle: TextStyle(color: context.textSecondary, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subjects = context.watch<SubjectViewModel>().subjects;
    final isSaving = context.watch<MaterialViewModel>().isSaving;
    final isDark = context.isDarkMode;

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
                  color: context.cardBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.initialMaterial != null
                      ? 'Edit Study Material'
                      : 'Upload Study Material',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: context.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                IconButton(
                  icon: Icon(LucideIcons.x, color: context.textSecondary),
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
              style: TextStyle(fontSize: 14, color: context.textPrimary),
              decoration: _inputDeco(
                context,
                'Document Title (e.g. OOP PPT or DBMS Notes)',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subject',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.textSecondary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final created = await AddEditSubjectDialog.show(context);
                    if (created != null && mounted) {
                      setState(() {
                        _selectedSubjectId = created.id;
                      });
                    }
                  },
                  icon: const Icon(LucideIcons.plus, size: 14),
                  label: const Text(
                    'New Subject',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: context.primaryAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String?>(
              value: subjects.any((s) => s.id == _selectedSubjectId)
                  ? _selectedSubjectId
                  : null,
              dropdownColor: context.cardBg,
              style: TextStyle(fontSize: 14, color: context.textPrimary),
              decoration: _inputDeco(context, 'Select Subject (Optional)'),
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text(
                    'No Subject (General)',
                    style: TextStyle(color: context.textSecondary),
                  ),
                ),
                ...subjects.map((sub) {
                  final displayCode =
                      (sub.code != null && sub.code!.isNotEmpty)
                          ? ' (${sub.code})'
                          : '';
                  return DropdownMenuItem<String?>(
                    value: sub.id,
                    child: Text(
                      '${sub.name}$displayCode',
                      style: TextStyle(color: context.textPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }),
                DropdownMenuItem<String?>(
                  value: '__create_new__',
                  child: Row(
                    children: [
                      Icon(LucideIcons.plusCircle,
                          size: 16, color: context.primaryAccent),
                      const SizedBox(width: 8),
                      Text(
                        '+ Add New Subject...',
                        style: TextStyle(
                          color: context.primaryAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              onChanged: (val) async {
                if (val == '__create_new__') {
                  final created = await AddEditSubjectDialog.show(context);
                  if (created != null && mounted) {
                    setState(() => _selectedSubjectId = created.id);
                  } else if (mounted) {
                    setState(() {});
                  }
                } else {
                  setState(() => _selectedSubjectId = val);
                }
              },
            ),
            const SizedBox(height: 14),

            // File Type Selector Chips
            Text(
              'File Format',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.textSecondary,
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
                          ? context.primaryAccent
                          : (isDark
                              ? const Color(0xFF262626)
                              : const Color(0xFFF3F4F6)),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? context.primaryAccent
                            : context.cardBorder,
                      ),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : context.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Browse File Action / Selected File Display
            if (_pickedFilePath != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.primaryAccent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.primaryAccent.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: context.primaryAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _selectedFileType == 'PDF'
                            ? LucideIcons.fileText
                            : (_selectedFileType == 'PPT'
                                ? LucideIcons.presentation
                                : LucideIcons.file),
                        color: context.primaryAccent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _pickedFileName ?? 'Selected File',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: context.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$_selectedFileType • $_selectedFileSize',
                            style: TextStyle(
                              fontSize: 12,
                              color: context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x, size: 18),
                      color: context.textSecondary,
                      tooltip: 'Remove File',
                      onPressed: () {
                        setState(() {
                          _pickedFilePath = null;
                          _pickedFileName = null;
                          _urlController.clear();
                        });
                      },
                    ),
                  ],
                ),
              )
            else
              InkWell(
                onTap: _pickFile,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF222222)
                        : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: context.cardBorder,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.uploadCloud,
                        color: context.primaryAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Browse and Upload File ($_selectedFileType)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: context.primaryAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),

            // Document Link / URL Option
            TextFormField(
              controller: _urlController,
              style: TextStyle(fontSize: 14, color: context.textPrimary),
              decoration: _inputDeco(
                context,
                'Or Paste Cloud Link (Google Drive, OneDrive, Web)',
              ),
            ),
            const SizedBox(height: 14),

            // Share Toggle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF222222) : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.cardBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Share with Classmates',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                  ),
                  Switch(
                    value: _isShared,
                    activeThumbColor: context.primaryAccent,
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
                  backgroundColor: context.primaryAccent,
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
                        widget.initialMaterial != null
                            ? 'Update Material'
                            : 'Upload Material',
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
