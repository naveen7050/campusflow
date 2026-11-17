import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:campusflow/app/theme/app_colors.dart';
import 'package:campusflow/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:campusflow/features/auth/presentation/views/login_view.dart';
import 'package:campusflow/features/subjects/presentation/views/subjects_view.dart';
import 'package:campusflow/features/subjects/presentation/viewmodels/subject_viewmodel.dart';
import 'package:campusflow/features/notes/presentation/viewmodels/note_viewmodel.dart';
import 'package:campusflow/features/questions/presentation/viewmodels/question_viewmodel.dart';
import 'package:campusflow/features/assignments/presentation/viewmodels/assignment_viewmodel.dart';
import 'package:campusflow/core/widgets/app_dialogs.dart';
import 'package:campusflow/core/widgets/app_background.dart';
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
      builder: (dialogCtx) {
        InputDecoration inputDecoration(String hint) {
          return InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 14, color: dialogCtx.textSecondary),
            filled: true,
            fillColor: dialogCtx.isDarkMode ? const Color(0xFF242424) : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: dialogCtx.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: dialogCtx.primaryAccent, width: 1.5),
            ),
          );
        }

        return AppCardDialog(
          icon: LucideIcons.userCheck,
          title: 'Edit Profile',
          subtitle: 'Update your student details',
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: TextStyle(fontSize: 14, color: dialogCtx.textPrimary),
                  decoration: inputDecoration('Full Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: deptController,
                  style: TextStyle(fontSize: 14, color: dialogCtx.textPrimary),
                  decoration: inputDecoration('Department'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: semController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 14, color: dialogCtx.textPrimary),
                  decoration: inputDecoration('Semester (Number)'),
                ),
              ],
            ),
          ),
          actions: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                  backgroundColor: dialogCtx.primaryAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(38),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: dialogCtx.primaryAccent,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showChangePasswordDialog(BuildContext context, AuthViewModel authVm) {
    final currentPassController = TextEditingController();
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();
    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setState) {
          InputDecoration passwordDecoration({
            required String hint,
            required bool isObscured,
            required VoidCallback onToggle,
          }) {
            return InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 14, color: dialogCtx.textSecondary),
              filled: true,
              fillColor: dialogCtx.isDarkMode ? const Color(0xFF242424) : Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: dialogCtx.cardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: dialogCtx.primaryAccent, width: 1.5),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isObscured ? LucideIcons.eyeOff : LucideIcons.eye,
                  size: 20,
                  color: dialogCtx.textSecondary,
                ),
                onPressed: onToggle,
              ),
            );
          }

          return AppCardDialog(
            icon: LucideIcons.lock,
            title: 'Change Password',
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: currentPassController,
                    obscureText: obscureCurrent,
                    style: TextStyle(fontSize: 14, color: dialogCtx.textPrimary),
                    decoration: passwordDecoration(
                      hint: 'Current Password',
                      isObscured: obscureCurrent,
                      onToggle: () => setState(() => obscureCurrent = !obscureCurrent),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: newPassController,
                    obscureText: obscureNew,
                    style: TextStyle(fontSize: 14, color: dialogCtx.textPrimary),
                    decoration: passwordDecoration(
                      hint: 'New Password',
                      isObscured: obscureNew,
                      onToggle: () => setState(() => obscureNew = !obscureNew),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: confirmPassController,
                    obscureText: obscureConfirm,
                    style: TextStyle(fontSize: 14, color: dialogCtx.textPrimary),
                    decoration: passwordDecoration(
                      hint: 'Confirm New Password',
                      isObscured: obscureConfirm,
                      onToggle: () => setState(() => obscureConfirm = !obscureConfirm),
                    ),
                  ),
                ],
              ),
            ),
            actions: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                    backgroundColor: dialogCtx.primaryAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Update',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 6),
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(38),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: dialogCtx.primaryAccent,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final titleColor = isDark ? Colors.white : const Color(0xFF1F2937);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: isTab
          ? null
          : AppBar(
              backgroundColor: bgColor,
              elevation: 0,
              leading: Navigator.canPop(context)
                  ? IconButton(
                      icon: const Icon(LucideIcons.chevronLeft, size: 20),
                      color: titleColor,
                      onPressed: () => Navigator.pop(context),
                    )
                  : null,
              title: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
            ),
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  if (isTab) ...[
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: context.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Hero Profile Card with Academic Banner
                  Container(
                    decoration: BoxDecoration(
                      color: context.cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: context.cardBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: context.isDarkMode ? 0.25 : 0.04,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Top Banner Image / Wave
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/images/profile_banner.jpg',
                                height: 110,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: 110,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        context.primaryAccent,
                                        context.isDarkMode
                                            ? const Color(0xFF142D1F)
                                            : const Color(0xFF2E7D32),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF4ADE80),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'Student',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Avatar & Details
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Transform.translate(
                                offset: const Offset(0, -22),
                                child: Container(
                                  width: 68,
                                  height: 68,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: context.cardBg,
                                      width: 3.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.12,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: context.primaryAccent,
                                    child: Text(
                                      initial,
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        displayName,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: context.textPrimary,
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        subtitle,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: context.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: context.iconContainerBg,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: context.cardBorder),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      LucideIcons.edit2,
                                      color: context.primaryAccent,
                                      size: 16,
                                    ),
                                    tooltip: 'Edit Profile',
                                    onPressed: () =>
                                        _showEditProfileDialog(context, authVm),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Quick Stats Row
                  Row(
                    children: [
                      _ProfileStatCard(
                        label: 'Subjects',
                        count: subjectVm.subjects.length,
                        icon: LucideIcons.bookOpen,
                        color: const Color(0xFF22C55E),
                      ),
                      const SizedBox(width: 8),
                      _ProfileStatCard(
                        label: 'Notes',
                        count: noteVm.notes.length,
                        icon: LucideIcons.fileText,
                        color: const Color(0xFF3B82F6),
                      ),
                      const SizedBox(width: 8),
                      _ProfileStatCard(
                        label: 'Questions',
                        count: questionVm.questions.length,
                        icon: LucideIcons.helpCircle,
                        color: const Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 8),
                      _ProfileStatCard(
                        label: 'Tasks',
                        count: assignmentVm.assignments.length,
                        icon: LucideIcons.clipboardList,
                        color: const Color(0xFF8B5CF6),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Group 1: Academic Workspace
                  _SectionTitle(title: 'Academic Workspace'),
                  const SizedBox(height: 8),
                  _GroupedMenuCard(
                    items: [
                      _MenuRow(
                        icon: LucideIcons.folder,
                        title: 'My Enrolled Subjects',
                        subtitle: 'Access syllabus, question banks and notes',
                        badgeText: '${subjectVm.subjects.length}',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SubjectsView(isTab: false),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Group 2: Account & Settings
                  _SectionTitle(title: 'Account & Settings'),
                  const SizedBox(height: 8),
                  _GroupedMenuCard(
                    items: [
                      _MenuRow(
                        icon: LucideIcons.lock,
                        title: 'Change Password',
                        subtitle: 'Update your account login credentials',
                        onTap: () => _showChangePasswordDialog(context, authVm),
                      ),
                      const _MenuDivider(),
                      _MenuRow(
                        icon: LucideIcons.settings,
                        title: 'Settings & Appearance',
                        subtitle: 'Dark mode, theme and notifications',
                        onTap: () {
                          Navigator.pushNamed(context, SettingsView.routeName);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Group 3: Support & About
                  _SectionTitle(title: 'Support & Info'),
                  const SizedBox(height: 8),
                  _GroupedMenuCard(
                    items: [
                      _MenuRow(
                        icon: LucideIcons.helpCircle,
                        title: 'Help & Support',
                        subtitle: 'Guides and customer support',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AppCardDialog(
                              icon: LucideIcons.helpCircle,
                              title: 'Help & Support',
                              subtitle:
                                  'Need assistance? Contact support@campusflow.app or view our user guide.',
                              actions: ElevatedButton(
                                onPressed: () => Navigator.pop(ctx),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ctx.primaryAccent,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(48),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const _MenuDivider(),
                      _MenuRow(
                        icon: LucideIcons.info,
                        title: 'About CampusFlow',
                        subtitle: 'Organize, Study, Share',
                        badgeText: 'v1.0.0',
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
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Logout Button
                  SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final confirm = await AppDialogs.showConfirm(
                          context,
                          title: 'Sign Out',
                          message: 'Are you sure you want\nto sign out?',
                          icon: LucideIcons.logOut,
                          confirmText: 'Sign Out',
                          cancelText: 'Cancel',
                          buttonLayout:
                              DialogButtonLayout.cancelTopConfirmBottom,
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
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: context.textSecondary,
        letterSpacing: 0.3,
      ),
    );
  }
}

class _GroupedMenuCard extends StatelessWidget {
  final List<Widget> items;

  const _GroupedMenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: context.isDarkMode ? 0.2 : 0.03,
            ),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: items,
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? badgeText;
  final VoidCallback onTap;

  const _MenuRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.badgeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: context.iconContainerBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 19, color: context.primaryAccent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: context.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (badgeText != null) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: context.iconContainerBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: context.cardBorder),
                  ),
                  child: Text(
                    badgeText!,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: context.primaryAccent,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: context.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: context.cardBorder.withValues(alpha: 0.6),
      indent: 68,
      endIndent: 16,
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color color;

  const _ProfileStatCard({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: context.isDarkMode ? 0.2 : 0.02,
              ),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(
                  alpha: context.isDarkMode ? 0.22 : 0.12,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: context.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
