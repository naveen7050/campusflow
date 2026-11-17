import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:campusflow/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:campusflow/features/auth/presentation/views/login_view.dart';
import 'package:campusflow/features/subjects/presentation/views/subjects_view.dart';
import 'package:campusflow/features/subjects/presentation/viewmodels/subject_viewmodel.dart';
import 'package:campusflow/features/notes/presentation/viewmodels/note_viewmodel.dart';
import 'package:campusflow/features/questions/presentation/viewmodels/question_viewmodel.dart';
import 'package:campusflow/features/assignments/presentation/viewmodels/assignment_viewmodel.dart';
import 'settings_view.dart';

class ProfileView extends StatelessWidget {
  static const String routeName = '/profile';
  final bool isTab;

  const ProfileView({super.key, this.isTab = false});

  void _showEditProfileDialog(BuildContext context, AuthViewModel authVm) {
    final user = authVm.user;
    final nameController = TextEditingController(text: user?.fullName ?? '');
    final deptController = TextEditingController(text: user?.department ?? '');
    final semController = TextEditingController(
      text: user?.semester != null ? user!.semester.toString() : '',
    );

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: deptController,
                decoration: const InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: semController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Semester (Number)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter your full name.')),
                );
                return;
              }
              final sem = int.tryParse(semController.text.trim());
              Navigator.pop(dialogCtx);
              final success = await authVm.updateProfile(
                fullName: name,
                department: deptController.text.trim().isEmpty
                    ? null
                    : deptController.text.trim(),
                semester: sem,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Profile updated successfully.'
                          : (authVm.errorMessage ?? 'Failed to update profile.'),
                    ),
                    backgroundColor:
                        success ? const Color(0xFF0F5132) : Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F5132),
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, AuthViewModel authVm) {
    final currentPassController = TextEditingController();
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();
    bool obscureCurrent = true;
    bool obscureNew = true;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Change Password'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPassController,
                  obscureText: obscureCurrent,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureCurrent
                            ? LucideIcons.eyeOff
                            : LucideIcons.eye,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => obscureCurrent = !obscureCurrent),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newPassController,
                  obscureText: obscureNew,
                  decoration: InputDecoration(
                    labelText: 'New Password (min 6 chars)',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureNew ? LucideIcons.eyeOff : LucideIcons.eye,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => obscureNew = !obscureNew),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmPassController,
                  obscureText: obscureNew,
                  decoration: const InputDecoration(
                    labelText: 'Confirm New Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final currentPass = currentPassController.text;
                final newPass = newPassController.text;
                final confirmPass = confirmPassController.text;

                if (currentPass.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter current password.'),
                    ),
                  );
                  return;
                }
                if (newPass.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('New password must be at least 6 characters.'),
                    ),
                  );
                  return;
                }
                if (newPass != confirmPass) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('New passwords do not match.'),
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogCtx);
                final success = await authVm.changePassword(
                  currentPassword: currentPass,
                  newPassword: newPass,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Password changed successfully.'
                            : (authVm.errorMessage ??
                                'Failed to change password.'),
                      ),
                      backgroundColor:
                          success ? const Color(0xFF0F5132) : Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F5132),
                foregroundColor: Colors.white,
              ),
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final user = authVm.user;

    final subjectVm = context.watch<SubjectViewModel>();
    final noteVm = context.watch<NoteViewModel>();
    final questionVm = context.watch<QuestionViewModel>();
    final assignmentVm = context.watch<AssignmentViewModel>();

    final displayName = user?.fullName ?? 'Student';
    final initial =
        displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';
    final dept = user?.department ?? 'General';
    final sem = user?.semester != null
        ? 'Semester ${user!.semester}'
        : 'Student';
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
                      icon: const Icon(LucideIcons.chevronLeft, size: 20),
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

                // User Info Header Card
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
                      IconButton(
                        icon: const Icon(
                          LucideIcons.edit2,
                          color: Color(0xFF0F5132),
                          size: 18,
                        ),
                        tooltip: 'Edit Profile',
                        onPressed: () => _showEditProfileDialog(context, authVm),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Dynamic 4-stat row
                Row(
                  children: [
                    _ProfileStatCard(
                      label: 'Subjects',
                      count: subjectVm.subjects.length,
                    ),
                    const SizedBox(width: 8),
                    _ProfileStatCard(
                      label: 'Notes',
                      count: noteVm.notes.length,
                    ),
                    const SizedBox(width: 8),
                    _ProfileStatCard(
                      label: 'Questions',
                      count: questionVm.questions.length,
                    ),
                    const SizedBox(width: 8),
                    _ProfileStatCard(
                      label: 'Tasks',
                      count: assignmentVm.assignments.length,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Menu Options
                _ProfileMenuItem(
                  icon: LucideIcons.folder,
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
                  icon: LucideIcons.lock,
                  title: 'Change Password',
                  onTap: () => _showChangePasswordDialog(context, authVm),
                ),
                const SizedBox(height: 12),
                _ProfileMenuItem(
                  icon: LucideIcons.settings,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pushNamed(context, SettingsView.routeName);
                  },
                ),
                const SizedBox(height: 12),
                _ProfileMenuItem(
                  icon: LucideIcons.helpCircle,
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
                  icon: LucideIcons.info,
                  title: 'About CampusFlow',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'CampusFlow',
                      applicationVersion: '1.0.0',
                      applicationLegalese:
                          '© 2026 CampusFlow. Organize, Study, Share.',
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
                          content:
                              const Text('Are you sure you want to sign out?'),
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
                    icon: const Icon(
                      LucideIcons.logOut,
                      color: Colors.red,
                      size: 18,
                    ),
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

class _ProfileStatCard extends StatelessWidget {
  final String label;
  final int count;

  const _ProfileStatCard({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F5132),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
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
              LucideIcons.chevronRight,
              size: 18,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}
