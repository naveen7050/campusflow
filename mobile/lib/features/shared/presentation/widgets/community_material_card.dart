import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:campusflow/app/theme/app_colors.dart';
import '../viewmodels/community_viewmodel.dart';

/// Card that displays a shared PDF or study material in the community feed.
class CommunityMaterialCard extends StatelessWidget {
  final CommunityItem item;
  final VoidCallback? onTap;

  const CommunityMaterialCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.cardBorder),
        ),
        child: Row(
          children: [
            // File type icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.isDarkMode
                    ? const Color(0xFFD97706).withValues(alpha: 0.15)
                    : const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _fileIcon(item.fileType),
                size: 24,
                color: context.isDarkMode
                    ? const Color(0xFFFBBF24)
                    : const Color(0xFFD97706),
              ),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: context.isDarkMode
                              ? const Color(0xFFD97706).withValues(alpha: 0.15)
                              : const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.fileType ?? 'PDF',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: context.isDarkMode
                                ? const Color(0xFFFBBF24)
                                : const Color(0xFFD97706),
                          ),
                        ),
                      ),
                      if (item.fileSize != null && item.fileSize!.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Text(
                          item.fileSize!,
                          style: TextStyle(
                            fontSize: 10,
                            color: context.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Title
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Author and subject
                  Row(
                    children: [
                      Icon(LucideIcons.user, size: 12, color: context.textSecondary),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          item.authorName,
                          style: TextStyle(
                              fontSize: 11, color: context.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (item.subjectName != null && item.subjectName!.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: context.textSecondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            item.subjectName!,
                            style: TextStyle(
                                fontSize: 11, color: context.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Open icon
            Icon(
              LucideIcons.chevronRight,
              size: 18,
              color: context.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  IconData _fileIcon(String? type) {
    switch (type?.toUpperCase()) {
      case 'PDF':
        return LucideIcons.fileText;
      case 'DOC':
      case 'DOCX':
        return LucideIcons.fileText;
      case 'PPT':
      case 'PPTX':
        return LucideIcons.presentation;
      case 'XLS':
      case 'XLSX':
        return LucideIcons.sheet;
      case 'IMG':
      case 'JPG':
      case 'PNG':
        return LucideIcons.image;
      default:
        return LucideIcons.folder;
    }
  }
}
