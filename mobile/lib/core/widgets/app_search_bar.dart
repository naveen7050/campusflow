import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final VoidCallback? onTap;
  final String hintText;
  final bool readOnly;
  final bool autofocus;

  const AppSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.onTap,
    this.hintText = 'Search...',
    this.readOnly = false,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF242424) : const Color(0xFFF3F4F6);
    final borderColor = isDark ? const Color(0xFF333333) : const Color(0xFFE5E7EB);
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final hintColor = isDark ? const Color(0xFF888888) : const Color(0xFF9CA3AF);

    final boxDecoration = BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: borderColor, width: 1),
    );

    if (readOnly) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 46,
          decoration: boxDecoration,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Icon(
                LucideIcons.search,
                color: hintColor,
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  hintText,
                  style: TextStyle(
                    color: hintColor,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 46,
      decoration: boxDecoration,
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        style: TextStyle(
          fontSize: 14,
          color: textColor,
        ),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.transparent,
          hintText: hintText,
          hintStyle: TextStyle(
            color: hintColor,
            fontSize: 13,
          ),
          prefixIcon: Icon(
            LucideIcons.search,
            color: hintColor,
            size: 18,
          ),
          suffixIcon: (controller != null && controller!.text.isNotEmpty && onClear != null)
              ? IconButton(
                  icon: Icon(LucideIcons.x, size: 16, color: hintColor),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}
