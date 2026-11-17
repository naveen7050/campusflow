import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:campusflow/features/subjects/domain/models/subject_model.dart';
import 'package:campusflow/features/subjects/presentation/viewmodels/subject_viewmodel.dart';
import 'package:campusflow/features/subjects/presentation/widgets/add_edit_subject_dialog.dart';
import 'package:campusflow/features/notes/presentation/views/notes_view.dart';
import 'package:campusflow/features/materials/presentation/views/materials_view.dart';
import 'package:campusflow/features/questions/presentation/views/questions_view.dart';
import 'package:campusflow/features/assignments/presentation/views/assignments_view.dart';
import 'package:campusflow/app/theme/app_colors.dart';
import 'package:campusflow/core/widgets/app_dialogs.dart';
import 'package:campusflow/core/widgets/app_background.dart';

class SubjectDetailView extends StatefulWidget {
  static const String routeName = '/subject-detail';

  final SubjectModel? subject;

  const SubjectDetailView({super.key, this.subject});

  @override
  State<SubjectDetailView> createState() => _SubjectDetailViewState();
}

class _SubjectDetailViewState extends State<SubjectDetailView> {
  SubjectModel? _subject;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_subject == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is SubjectModel) {
        _subject = args;
      } else {
        _subject = widget.subject;
      }
    }
  }

  Color _parseColor(String colorStr) {
    try {
      final hex = colorStr.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return const Color(0xFF0F5132);
    }
  }

  IconData _getIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'code':
        return LucideIcons.code;
      case 'storage':
      case 'database':
        return LucideIcons.database;
      case 'web':
        return LucideIcons.globe;
      case 'phone':
      case 'android':
        return LucideIcons.smartphone;
      case 'calculate':
        return LucideIcons.calculator;
      case 'science':
        return LucideIcons.flaskConical;
      default:
        return LucideIcons.bookOpen;
    }
  }

  Future<void> _handleDelete() async {
    if (_subject == null) return;

    final confirmed = await AppDialogs.showDeleteConfirm(
      context,
      itemType: 'Subject',
      itemName: _subject!.name,
    );

    if (confirmed == true && mounted) {
      final success =
          await context.read<SubjectViewModel>().deleteSubject(_subject!.id);
      if (success && mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _handleEdit() async {
    if (_subject == null) return;

    final updated = await AddEditSubjectDialog.show(
      context,
      subject: _subject,
    );

    if (updated == true && mounted) {
      final vm = context.read<SubjectViewModel>();
      final fresh = vm.subjects.firstWhere(
        (s) => s.id == _subject!.id,
        orElse: () => _subject!,
      );
      setState(() => _subject = fresh);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_subject == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Subject Detail')),
        body: const Center(child: Text('No subject data found.')),
      );
    }

    final subject = _subject!;
    final themeColor = _parseColor(subject.color);

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
          subject.name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: context.textPrimary,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(LucideIcons.moreVertical, color: context.textPrimary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (val) {
              if (val == 'edit') {
                _handleEdit();
              } else if (val == 'delete') {
                _handleDelete();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(LucideIcons.edit2, size: 18),
                    SizedBox(width: 8),
                    Text('Edit Subject'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(LucideIcons.trash2,
                        size: 18, color: Color(0xFFEF4444)),
                    SizedBox(width: 8),
                    Text('Delete',
                        style: TextStyle(color: Color(0xFFEF4444))),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: themeColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: themeColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: themeColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                _getIcon(subject.icon),
                                size: 32,
                                color: themeColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subject.name,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: context.textPrimary,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      if (subject.code != null) ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: themeColor.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            subject.code!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: themeColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      if (subject.semester != null)
                                        Text(
                                          'Semester ${subject.semester}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF6B7280),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Description Section
                      if (subject.description != null &&
                          subject.description!.isNotEmpty) ...[
                        const Text(
                          'Description & Syllabus',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: context.cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: context.cardBorder),
                          ),
                          child: Text(
                            subject.description!,
                            style: TextStyle(
                              fontSize: 14,
                              color: context.textPrimary,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                      ],

                      // Modules Header
                      Text(
                        'Subject Resources',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 4 Resource Tiles (Matches screens 8, 9, 10, 11, 12)
                      _ResourceTile(
                        icon: LucideIcons.helpCircle,
                        title: 'Question Bank',
                        subtitle: 'Review & practice past questions',
                        color: const Color(0xFF0F5132),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuestionsView(
                                subjectId: subject.id,
                                subjectName: subject.name,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      _ResourceTile(
                        icon: LucideIcons.fileText,
                        title: 'Subject Notes',
                        subtitle: 'Read and create study notes',
                        color: const Color(0xFF2E7D32),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NotesView(
                                subjectId: subject.id,
                                subjectName: subject.name,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      _ResourceTile(
                        icon: LucideIcons.folder,
                        title: 'Study Materials',
                        subtitle: 'PDFs, slides, and syllabus documents',
                        color: const Color(0xFF1E3A8A),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MaterialsView(
                                subjectId: subject.id,
                                subjectName: subject.name,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      _ResourceTile(
                        icon: LucideIcons.clipboardList,
                        title: 'Assignments',
                        subtitle: 'Track assignments & submission deadlines',
                        color: const Color(0xFFD97706),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AssignmentsView(
                                subjectId: subject.id,
                                subjectName: subject.name,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
}

class _ResourceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ResourceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.cardBorder),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: context.isDarkMode ? 0.22 : 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: context.isDarkMode ? context.primaryAccent : color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: context.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: context.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

