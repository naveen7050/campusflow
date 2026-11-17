import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:campusflow/app/theme/app_colors.dart';
import '../../domain/models/subject_model.dart';

class SubjectCard extends StatelessWidget {
  final SubjectModel subject;
  final VoidCallback? onTap;

  const SubjectCard({
    super.key,
    required this.subject,
    this.onTap,
  });

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

  @override
  Widget build(BuildContext context) {
    final themeColor = _parseColor(subject.color);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: context.isDarkMode ? 0.2 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Subject Icon Container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: themeColor.withValues(alpha: context.isDarkMode ? 0.22 : 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIcon(subject.icon),
                    size: 24,
                    color: themeColor,
                  ),
                ),
                const SizedBox(width: 14),
                // Subject Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: context.textPrimary,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (subject.code != null &&
                              subject.code!.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: context.iconContainerBg,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                subject.code!,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: context.primaryAccent,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          if (subject.semester != null)
                            Text(
                              'Semester ${subject.semester}',
                              style: TextStyle(
                                fontSize: 12,
                                color: context.textSecondary,
                              ),
                            ),
                          if (subject.semester == null &&
                              subject.department != null)
                            Expanded(
                              child: Text(
                                subject.department!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  LucideIcons.chevronRight,
                  color: context.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

