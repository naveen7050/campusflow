import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campusflow/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:campusflow/features/auth/presentation/views/login_view.dart';
import 'package:campusflow/features/subjects/presentation/views/subjects_view.dart';
import 'settings_view.dart';

class ProfileView extends StatelessWidget {
  static const String routeName = '/profile';
  final bool isTab;

  const ProfileView({super.key, this.isTab = false});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final user = authVm.user;

    final displayName = user?.fullName ?? 'Naveen Kumar';
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';
    final dept = user?.department ?? 'Computer Science';
    final sem = user?.semester != null ? 'Semester ${user!.semester}' : '2nd Year';
    final subtitle = '$dept • $sem';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isTab
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: Navigator.canPop(context)
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                      color: const Color(0xFF1F2937),
                      onPressed: () => Navigator.pop(context),
                    )
                  : null,
              title: const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                if (isTab) ...[
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2937),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // User Info Header Card (Matches Screen 15)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0F5132),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            initial,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Menu Options (Matches Screen 15)
                _ProfileMenuItem(
                  icon: Icons.folder_outlined,
                  title: 'My Resources',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SubjectsView(isTab: false),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _ProfileMenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pushNamed(context, SettingsView.routeName);
                  },
                ),
                const SizedBox(height: 12),
                _ProfileMenuItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Support',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Help & Support'),
                        content: const Text(
                          'Need assistance? Contact support@campusflow.app or view our user guide.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _ProfileMenuItem(
                  icon: Icons.info_outline_rounded,
                  title: 'About CampusFlow',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'CampusFlow',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2026 CampusFlow. Organize, Study, Share.',
                    );
                  },
                ),
                const SizedBox(height: 28),

                // Logout Button
                SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Sign Out'),
                          content: const Text('Are you sure you want to sign out?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Sign Out'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true && context.mounted) {
                        await authVm.logout();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            LoginView.routeName,
                            (route) => false,
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
                    label: const Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFCA5A5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
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
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF0F5132)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}

