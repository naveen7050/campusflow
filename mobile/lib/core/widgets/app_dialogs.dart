import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:campusflow/app/theme/app_colors.dart';

enum DialogButtonLayout {
  /// Cancel outlined on top, Confirm filled on bottom (as in Sign Out mockup)
  cancelTopConfirmBottom,
  /// Confirm filled on top, Cancel text button on bottom (as in Change Password mockup)
  confirmTopCancelBottom,
  /// Side by side buttons (Cancel on left, Confirm on right)
  sideBySide,
}

/// A reusable modal card frame matching the CampusFlow dialog design.
class AppCardDialog extends StatelessWidget {
  final Widget? badge;
  final IconData? icon;
  final Color? iconColor;
  final Color? badgeColor;
  final String title;
  final String? subtitle;
  final Widget? content;
  final Widget? actions;
  final VoidCallback? onClose;
  final double maxWidth;

  const AppCardDialog({
    super.key,
    this.badge,
    this.icon,
    this.iconColor,
    this.badgeColor,
    required this.title,
    this.subtitle,
    this.content,
    this.actions,
    this.onClose,
    this.maxWidth = 360,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? context.primaryAccent;
    final effectiveBadgeColor = badgeColor ??
        (context.isDarkMode
            ? const Color(0xFF1B3224)
            : const Color(0xFFE2F4E7));

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      elevation: 0,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: context.cardBorder, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: context.isDarkMode ? 0.35 : 0.08),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              children: [
                // Bottom-left organic background blob
                Positioned(
                  bottom: -35,
                  left: -35,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: context.isDarkMode
                          ? const Color(0xFF1B2E23).withValues(alpha: 0.5)
                          : const Color(0xFFE2F4E7).withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Bottom-right organic background blob
                Positioned(
                  bottom: -45,
                  right: -30,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: context.isDarkMode
                          ? const Color(0xFF1B2E23).withValues(alpha: 0.35)
                          : const Color(0xFFE2F4E7).withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // Main card content
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Badge icon
                      if (badge != null)
                        Center(child: badge!)
                      else if (icon != null)
                        Center(
                          child: Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              color: effectiveBadgeColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icon!,
                              size: 34,
                              color: effectiveIconColor,
                            ),
                          ),
                        ),

                      if (icon != null || badge != null)
                        const SizedBox(height: 16),

                      // Title
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: context.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),

                      // Subtitle
                      if (subtitle != null && subtitle!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          subtitle!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: context.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],

                      // Optional Form / Content
                      if (content != null) ...[
                        const SizedBox(height: 18),
                        content!,
                      ],

                      // Actions
                      if (actions != null) ...[
                        const SizedBox(height: 22),
                        actions!,
                      ],
                    ],
                  ),
                ),

                // Top-right close button (X)
                Positioned(
                  top: 14,
                  right: 14,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: onClose ?? () => Navigator.of(context).pop(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: context.isDarkMode
                              ? const Color(0xFF2C2C2C)
                              : const Color(0xFFF3F4F6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.x,
                          size: 16,
                          color: context.isDarkMode
                              ? Colors.white70
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper functions to show standard styled dialogs.
class AppDialogs {
  AppDialogs._();

  /// Shows confirmation dialog (e.g. Sign Out, Delete, Action Confirm)
  static Future<bool?> showConfirm(
    BuildContext context, {
    required String title,
    required String message,
    IconData icon = LucideIcons.logOut,
    Color? iconColor,
    Color? badgeColor,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDanger = false,
    DialogButtonLayout buttonLayout = DialogButtonLayout.cancelTopConfirmBottom,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) {
        final primaryColor = isDanger
            ? const Color(0xFFDC2626)
            : ctx.primaryAccent;
        final effectiveBadgeColor = badgeColor ??
            (isDanger
                ? (ctx.isDarkMode ? const Color(0xFF331616) : const Color(0xFFFEE2E2))
                : (ctx.isDarkMode ? const Color(0xFF1B3224) : const Color(0xFFE2F4E7)));
        final effectiveIconColor = iconColor ?? primaryColor;

        Widget buildConfirmButton() {
          return ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              confirmText,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }

        Widget buildCancelButton({bool isOutlined = true}) {
          if (isOutlined) {
            return OutlinedButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                side: BorderSide(
                  color: isDanger ? const Color(0xFF9CA3AF) : ctx.primaryAccent,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                cancelText,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDanger ? ctx.textPrimary : ctx.primaryAccent,
                ),
              ),
            );
          }
          return TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            style: TextButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
            ),
            child: Text(
              cancelText,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: ctx.primaryAccent,
              ),
            ),
          );
        }

        Widget actionsWidget;
        if (buttonLayout == DialogButtonLayout.cancelTopConfirmBottom) {
          actionsWidget = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildCancelButton(isOutlined: true),
              const SizedBox(height: 12),
              buildConfirmButton(),
            ],
          );
        } else if (buttonLayout == DialogButtonLayout.confirmTopCancelBottom) {
          actionsWidget = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildConfirmButton(),
              const SizedBox(height: 8),
              buildCancelButton(isOutlined: false),
            ],
          );
        } else {
          actionsWidget = Row(
            children: [
              Expanded(child: buildCancelButton(isOutlined: true)),
              const SizedBox(width: 12),
              Expanded(child: buildConfirmButton()),
            ],
          );
        }

        return AppCardDialog(
          icon: icon,
          iconColor: effectiveIconColor,
          badgeColor: effectiveBadgeColor,
          title: title,
          subtitle: message,
          actions: actionsWidget,
          onClose: () => Navigator.of(ctx).pop(false),
        );
      },
    );
  }

  /// Shows danger delete confirmation dialog
  static Future<bool?> showDeleteConfirm(
    BuildContext context, {
    required String itemType,
    String? itemName,
  }) {
    final title = 'Delete $itemType';
    final message = itemName != null && itemName.isNotEmpty
        ? 'Are you sure you want to delete "$itemName"? This cannot be undone.'
        : 'Are you sure you want to delete this $itemType? This cannot be undone.';

    return showConfirm(
      context,
      title: title,
      message: message,
      icon: LucideIcons.trash2,
      confirmText: 'Delete',
      cancelText: 'Cancel',
      isDanger: true,
      buttonLayout: DialogButtonLayout.cancelTopConfirmBottom,
    );
  }
}
