import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/subject_model.dart';
import '../viewmodels/subject_viewmodel.dart';
import '../widgets/add_edit_subject_dialog.dart';
import '../../notes/presentation/views/notes_view.dart';
import '../../materials/presentation/views/materials_view.dart';
import '../../questions/presentation/views/create_question_view.dart';

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
        return Icons.code_rounded;
      case 'storage':
      case 'database':
        return Icons.storage_rounded;
      case 'web':
        return Icons.language_rounded;
      case 'phone':
      case 'android':
        return Icons.android_rounded;
      case 'calculate':
        return Icons.calculate_rounded;
      case 'science':
        return Icons.science_rounded;
      default:
        return Icons.menu_book_rounded;
    }
  }

  Future<void> _handleDelete() async {
    if (_subject == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Subject'),
        content: Text(
          'Are you sure you want to delete "${_subject!.name}"? All associated notes and materials will be removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          color: const Color(0xFF1F2937),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          subject.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFF1F2937)),
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
                    Icon(Icons.edit_outlined, size: 18),
                    SizedBox(width: 8),
                    Text('Edit Subject'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline,
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
      body: SafeArea(
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
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1F2937),
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
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Text(
                            subject.description!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4B5563),
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                      ],

                      // Modules Header
                      const Text(
                        'Subject Resources',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 4 Resource Tiles (Matches screens 8, 9, 10, 11, 12)
                      _ResourceTile(
                        icon: Icons.quiz_outlined,
                        title: 'Question Bank',
                        subtitle: 'Review & practice past questions',
                        color: const Color(0xFF0F5132),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            CreateQuestionView.routeName,
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      _ResourceTile(
                        icon: Icons.notes_outlined,
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
                        icon: Icons.folder_outlined,
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
                        icon: Icons.assignment_outlined,
                        title: 'Assignments',
                        subtitle: 'Track assignments & submission deadlines',
                        color: const Color(0xFFD97706),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
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
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFF9CA3AF),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

