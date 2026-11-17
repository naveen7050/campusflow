import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
                    color: themeColor.withValues(alpha: 0.12),
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
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2937),
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
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                subject.code!,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF4B5563),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          if (subject.semester != null)
                            Text(
                              'Semester ${subject.semester}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          if (subject.semester == null &&
                              subject.department != null)
                            Expanded(
                              child: Text(
                                subject.department!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6B7280),
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
                const Icon(
                  LucideIcons.chevronRight,
                  color: Color(0xFF9CA3AF),
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

