import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:campusflow/app/theme/app_colors.dart';
import 'package:campusflow/core/widgets/app_background.dart';
import 'package:campusflow/features/notes/presentation/views/create_note_view.dart';
import 'package:campusflow/features/materials/presentation/widgets/add_material_dialog.dart';
import 'package:campusflow/features/questions/presentation/views/create_question_view.dart';
import 'package:campusflow/features/assignments/presentation/widgets/add_assignment_dialog.dart';

class AddContentView extends StatelessWidget {
  static const String routeName = '/add-content';

  const AddContentView({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Add Content',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: context.textPrimary,
          ),
        ),
      ),
      body: AppBackground(
        child: SafeArea(
          child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                _AddContentCard(
                  icon: LucideIcons.helpCircle,
                  iconColor: const Color(0xFF0F5132),
                  iconBg: const Color(0xFFEBF5E9),
                  title: 'Add Question',
                  subtitle: 'Type and save important questions',
                  onTap: () {
                    Navigator.pushNamed(context, CreateQuestionView.routeName);
                  },
                ),
                const SizedBox(height: 14),
                _AddContentCard(
                  icon: LucideIcons.fileText,
                  iconColor: const Color(0xFF2E7D32),
                  iconBg: const Color(0xFFE8F5E9),
                  title: 'Add Note',
                  subtitle: 'Write or upload your notes',
                  onTap: () {
                    Navigator.pushNamed(context, CreateNoteView.routeName);
                  },
                ),
                const SizedBox(height: 14),
                _AddContentCard(
                  icon: LucideIcons.folder,
                  iconColor: const Color(0xFF1E3A8A),
                  iconBg: const Color(0xFFEFF6FF),
                  title: 'Add Study Material',
                  subtitle: 'Upload PDFs, images or links',
                  onTap: () {
                    AddMaterialDialog.show(context);
                  },
                ),
                const SizedBox(height: 14),
                _AddContentCard(
                  icon: LucideIcons.clipboardList,
                  iconColor: const Color(0xFFD97706),
                  iconBg: const Color(0xFFFFFBEB),
                  title: 'Add Assignment',
                  subtitle: 'Keep track of your assignments',
                  onTap: () {
                    AddAssignmentDialog.show(context);
                  },
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

class _AddContentCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AddContentCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconBg = context.isDarkMode
        ? iconBg.withValues(alpha: 0.15)
        : iconBg;
    final effectiveIconColor = context.isDarkMode
        ? context.primaryAccent
        : iconColor;

    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.cardBorder),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: effectiveIconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 26, color: effectiveIconColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: context.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  size: 18,
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

