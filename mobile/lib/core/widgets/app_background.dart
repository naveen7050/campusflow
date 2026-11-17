import 'package:flutter/material.dart';
import 'package:campusflow/app/theme/app_colors.dart';

/// Reusable background widget.
/// - In light mode: displays the exact splash screen organic circle blobs.
/// - In dark mode: uses a diffused radial gradient without hard edges
///   to prevent harsh circular cutoffs across dark cards and text.
class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Stack(
      children: [
        // Base background fill
        Positioned.fill(
          child: ColoredBox(
            color: context.scaffoldBg,
          ),
        ),

        // Top-left organic background element
        Positioned(
          top: isDark ? -130 : -70,
          left: isDark ? -110 : -70,
          child: IgnorePointer(
            child: Container(
              width: isDark ? 320 : 230,
              height: isDark ? 320 : 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? null : const Color(0xFFE2F4E7),
                gradient: isDark
                    ? RadialGradient(
                        colors: [
                          const Color(0xFF1B4D30).withValues(alpha: 0.20),
                          const Color(0xFF133622).withValues(alpha: 0.08),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      )
                    : null,
              ),
            ),
          ),
        ),

        // Bottom-right organic background element
        Positioned(
          bottom: isDark ? -130 : -80,
          right: isDark ? -110 : -80,
          child: IgnorePointer(
            child: Container(
              width: isDark ? 320 : 250,
              height: isDark ? 320 : 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? null : const Color(0xFFE2F4E7),
                gradient: isDark
                    ? RadialGradient(
                        colors: [
                          const Color(0xFF1B4D30).withValues(alpha: 0.18),
                          const Color(0xFF133622).withValues(alpha: 0.06),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      )
                    : null,
              ),
            ),
          ),
        ),

        // Screen Content
        child,
      ],
    );
  }
}
