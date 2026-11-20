import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:campusflow/app/theme/app_colors.dart';
import '../viewmodels/community_viewmodel.dart';

/// Card that displays a shared revision note in the community feed.
class CommunityNoteCard extends StatelessWidget {
  final CommunityItem item;
  final VoidCallback? onTap;

  const CommunityNoteCard({
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category badge row
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: context.isDarkMode
                        ? const Color(0xFF0F5132).withValues(alpha: 0.2)
                        : const Color(0xFFEBF5E9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.fileText,
                        size: 12,
                        color: context.primaryAccent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Note',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: context.primaryAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                if (item.subjectName != null &&
                    item.subjectName!.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      item.subjectName!,
                      style: TextStyle(
                        fontSize: 11,
                        color: context.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),

            // Note title
            Text(
              item.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: context.textPrimary,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Content preview
            if (item.content != null && item.content!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                item.content!,
                style: TextStyle(
                  fontSize: 13,
                  color: context.textSecondary,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            // Tags
            if (item.tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: item.tags.take(4).map((tag) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: context.isDarkMode
                          ? const Color(0xFF262626)
                          : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '#$tag',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: context.textSecondary,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 10),

            // Author and time
            Row(
              children: [
                Icon(LucideIcons.user, size: 13, color: context.textSecondary),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    item.authorName,
                    style:
                        TextStyle(fontSize: 12, color: context.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(LucideIcons.clock, size: 12, color: context.textSecondary),
                const SizedBox(width: 3),
                Text(
                  _formatTimeAgo(item.createdAt),
                  style: TextStyle(fontSize: 11, color: context.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime? date) {
    if (date == null) return 'Recently';
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now'; // also covers clock skew
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}