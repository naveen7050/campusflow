import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:campusflow/app/theme/theme_viewmodel.dart';
import 'package:campusflow/app/theme/app_colors.dart';
import 'package:campusflow/core/widgets/app_background.dart';

class SettingsView extends StatefulWidget {
  static const String routeName = '/settings';

  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _enableNotifications = true;

  @override
  Widget build(BuildContext context) {
    final themeVm = context.watch<ThemeViewModel>();
    final currentTheme = themeVm.themeModeName;

    final bgColor = context.scaffoldBg;
    final cardBg = context.cardBg;
    final borderColor = context.cardBorder;
    final textColor = context.textPrimary;
    final subTextColor = context.textSecondary;
    final accentColor = context.primaryAccent;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, size: 20),
          color: textColor,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              children: [
                // Appearance Section
                Text(
                  'Appearance',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    children: [
                      _RadioThemeItem(
                        title: 'Light',
                        value: 'Light',
                        groupValue: currentTheme,
                        textColor: textColor,
                        accentColor: accentColor,
                        onChanged: (val) => themeVm.setThemeByName(val),
                      ),
                      Divider(height: 1, thickness: 1, color: borderColor),
                      _RadioThemeItem(
                        title: 'Dark',
                        value: 'Dark',
                        groupValue: currentTheme,
                        textColor: textColor,
                        accentColor: accentColor,
                        onChanged: (val) => themeVm.setThemeByName(val),
                      ),
                      Divider(height: 1, thickness: 1, color: borderColor),
                      _RadioThemeItem(
                        title: 'System',
                        value: 'System',
                        groupValue: currentTheme,
                        textColor: textColor,
                        accentColor: accentColor,
                        onChanged: (val) => themeVm.setThemeByName(val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Notifications Section
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Enable Notifications',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      Switch(
                        value: _enableNotifications,
                        activeThumbColor: accentColor,
                        activeTrackColor: accentColor.withValues(alpha: 0.4),
                        onChanged: (val) =>
                            setState(() => _enableNotifications = val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _SettingsTile(
                  title: 'Manage Notifications',
                  cardBg: cardBg,
                  borderColor: borderColor,
                  textColor: textColor,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notification categories preferences'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // App Info Section
                Text(
                  'App Info',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Version',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      Text(
                        '1.0.0',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: subTextColor,
                        ),
                      ),
                    ],
                  ),
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

class _RadioThemeItem extends StatelessWidget {
  final String title;
  final String value;
  final String groupValue;
  final Color textColor;
  final Color accentColor;
  final ValueChanged<String> onChanged;

  const _RadioThemeItem({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.textColor,
    required this.accentColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? accentColor : const Color(0xFF9CA3AF),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accentColor,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final Color cardBg;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.title,
    required this.cardBg,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            const Icon(
              LucideIcons.chevronRight,
              size: 20,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}
