import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:campusflow/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:campusflow/features/auth/presentation/views/login_view.dart';
import 'package:campusflow/features/subjects/presentation/views/subjects_view.dart';
import 'add_content_view.dart';
import 'package:campusflow/features/notes/presentation/views/notes_view.dart';
import 'package:campusflow/features/materials/presentation/views/materials_view.dart';
import 'package:campusflow/features/questions/presentation/views/questions_view.dart';
import 'package:campusflow/app/theme/app_colors.dart';
import 'package:campusflow/features/assignments/presentation/views/assignments_view.dart';
import 'package:campusflow/core/widgets/app_search_bar.dart';
import 'package:campusflow/core/widgets/app_dialogs.dart';
import 'package:campusflow/core/widgets/app_background.dart';
import 'package:campusflow/features/shared/presentation/views/shared_with_me_view.dart';
import 'package:campusflow/features/profile/presentation/views/profile_view.dart';
import 'package:campusflow/features/search/presentation/views/search_view.dart';
import 'package:campusflow/features/subjects/presentation/viewmodels/subject_viewmodel.dart';
import 'package:campusflow/features/notes/presentation/viewmodels/note_viewmodel.dart';
import 'package:campusflow/features/materials/presentation/viewmodels/material_viewmodel.dart';
import 'package:campusflow/features/questions/presentation/viewmodels/question_viewmodel.dart';
import 'package:campusflow/features/assignments/presentation/viewmodels/assignment_viewmodel.dart';

class HomeView extends StatefulWidget {
  static const String routeName = '/home';

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshAll();
    });
  }

  Future<void> _refreshAll() async {
    if (!mounted) return;
    await Future.wait([
      context.read<SubjectViewModel>().fetchSubjects(),
      context.read<NoteViewModel>().fetchNotes(),
      context.read<MaterialViewModel>().fetchMaterials(),
      context.read<QuestionViewModel>().fetchQuestions(),
      context.read<AssignmentViewModel>().fetchAssignments(),
    ]);
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Future<void> _handleLogout(AuthViewModel authViewModel) async {
    final shouldLogout = await AppDialogs.showConfirm(
      context,
      title: 'Sign Out',
      message: 'Are you sure you want\nto sign out?',
      icon: LucideIcons.logOut,
      confirmText: 'Sign Out',
      cancelText: 'Cancel',
      buttonLayout: DialogButtonLayout.cancelTopConfirmBottom,
    );

    if (shouldLogout == true) {
      await authViewModel.logout();
      if (mounted) {
        Navigator.pushReplacementNamed(context, LoginView.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.user;
    final firstName = user?.fullName.split(' ').first ?? 'Student';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _selectedIndex == 0
          ? AppBackground(
              child: SafeArea(child: _buildHomeBody(authViewModel, user, firstName)),
            )
          : _buildPlaceholder(_selectedIndex),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildFab(authViewModel),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHomeBody(dynamic authViewModel, dynamic user, String firstName) {
    final questionVm = context.watch<QuestionViewModel>();
    final noteVm = context.watch<NoteViewModel>();
    final materialVm = context.watch<MaterialViewModel>();
    final assignmentVm = context.watch<AssignmentViewModel>();

    final recentItems = <_DashboardRecentItem>[];

    for (final q in questionVm.questions) {
      recentItems.add(_DashboardRecentItem(
        title: q.question,
        subtitle: q.subjectName ?? 'Question',
        icon: LucideIcons.helpCircle,
        iconBg: const Color(0xFFEBF5E9),
        iconColor: const Color(0xFF0F5132),
        createdAt: q.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
        onTap: () => Navigator.pushNamed(context, QuestionsView.routeName),
      ));
    }

    for (final n in noteVm.notes) {
      recentItems.add(_DashboardRecentItem(
        title: n.title,
        subtitle: n.subjectName ?? 'Note',
        icon: LucideIcons.fileText,
        iconBg: const Color(0xFFEBF5E9),
        iconColor: const Color(0xFF0F5132),
        createdAt: n.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
        onTap: () => Navigator.pushNamed(context, NotesView.routeName),
      ));
    }

    for (final m in materialVm.materials) {
      recentItems.add(_DashboardRecentItem(
        title: m.title,
        subtitle: m.subjectName ?? m.fileType.toUpperCase(),
        icon: LucideIcons.folder,
        iconBg: const Color(0xFFEBF5E9),
        iconColor: const Color(0xFF0F5132),
        createdAt: m.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
        onTap: () => Navigator.pushNamed(context, MaterialsView.routeName),
      ));
    }

    for (final a in assignmentVm.assignments) {
      final dueStr = a.dueDate != null
          ? 'Due: ${a.dueDate!.day}/${a.dueDate!.month}/${a.dueDate!.year}'
          : (a.subjectName ?? 'Assignment');
      recentItems.add(_DashboardRecentItem(
        title: a.title,
        subtitle: dueStr,
        icon: LucideIcons.clipboardList,
        iconBg: const Color(0xFFFFFBEB),
        iconColor: const Color(0xFFD97706),
        createdAt: a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0),
        onTap: () => Navigator.pushNamed(context, AssignmentsView.routeName),
      ));
    }

    recentItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final displayRecent = recentItems.take(5).toList();

    return RefreshIndicator(
      onRefresh: _refreshAll,
      color: const Color(0xFF0F5132),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar
                  Row(
                    children: [
                      // Logo
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF5E9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          LucideIcons.bookOpen,
                          size: 20,
                          color: Color(0xFF0F5132),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'CampusFlow',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: context.primaryAccent,
                        ),
                      ),
                      const Spacer(),
                      // Notification
                      IconButton(
                        icon: Icon(
                          LucideIcons.bell,
                          color: context.textPrimary,
                          size: 22,
                        ),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 12),
                      // Avatar / logout
                      GestureDetector(
                        onTap: () => _handleLogout(authViewModel),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: context.primaryAccent,
                          child: Text(
                            user != null && user.fullName.isNotEmpty
                                ? user.fullName[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Greeting
                  Text(
                    '${_getGreeting()}, $firstName 👋',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: context.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Search bar
                  AppSearchBar(
                    readOnly: true,
                    hintText: 'Search notes, questions, or files...',
                    onTap: () => Navigator.pushNamed(context, SearchView.routeName),
                  ),
                  const SizedBox(height: 20),

                  // Quick stats
                  Row(
                    children: [
                      _StatChip(
                        icon: LucideIcons.helpCircle,
                        label: 'Questions',
                        count: '${questionVm.questions.length} items',
                        onTap: () => Navigator.pushNamed(
                          context,
                          QuestionsView.routeName,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatChip(
                        icon: LucideIcons.fileText,
                        label: 'Notes',
                        count: '${noteVm.notes.length} items',
                        onTap: () => Navigator.pushNamed(
                          context,
                          NotesView.routeName,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatChip(
                        icon: LucideIcons.folder,
                        label: 'Materials',
                        count: '${materialVm.materials.length} items',
                        onTap: () => Navigator.pushNamed(
                          context,
                          MaterialsView.routeName,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatChip(
                        icon: LucideIcons.clipboardList,
                        label: 'Tasks',
                        count: '${assignmentVm.assignments.length} items',
                        onTap: () => Navigator.pushNamed(
                          context,
                          AssignmentsView.routeName,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Recent header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _selectedIndex = 1),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'View all >',
                          style: TextStyle(
                            fontSize: 13,
                            color: context.primaryAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Recent items
                  if (displayRecent.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: context.cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.cardBorder),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.history,
                              size: 36,
                              color: context.textSecondary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No recent activity yet',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: context.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Add notes, questions, or assignments to track them here.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: context.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...displayRecent.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _RecentItem(
                            icon: item.icon,
                            iconBg: item.iconBg,
                            iconColor: item.iconColor,
                            title: item.title,
                            subtitle: item.subtitle,
                            onTap: item.onTap,
                          ),
                        )),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(int index) {
    if (index == 1) {
      return const SubjectsView(isTab: true);
    }
    if (index == 3) {
      return const SharedWithMeView(isTab: true);
    }
    if (index == 4) {
      return const ProfileView(isTab: true);
    }
    return const SizedBox.shrink();
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      color: Theme.of(context).cardColor,
      elevation: 8,
      shadowColor: Colors.black12,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: LucideIcons.home,
              activeIcon: LucideIcons.home,
              label: 'Home',
              index: 0,
              selectedIndex: _selectedIndex,
              onTap: (i) => setState(() => _selectedIndex = i),
            ),
            _NavItem(
              icon: LucideIcons.compass,
              activeIcon: LucideIcons.compass,
              label: 'Explore',
              index: 1,
              selectedIndex: _selectedIndex,
              onTap: (i) => setState(() => _selectedIndex = i),
            ),
            const SizedBox(width: 48), // Space for FAB
            _NavItem(
              icon: LucideIcons.share2,
              activeIcon: LucideIcons.share2,
              label: 'Shared',
              index: 3,
              selectedIndex: _selectedIndex,
              onTap: (i) => setState(() => _selectedIndex = i),
            ),
            _NavItem(
              icon: LucideIcons.user,
              activeIcon: LucideIcons.user,
              label: 'Profile',
              index: 4,
              selectedIndex: _selectedIndex,
              onTap: (i) => setState(() => _selectedIndex = i),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFab(dynamic authViewModel) {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, AddContentView.routeName),
      backgroundColor: context.primaryAccent,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: const CircleBorder(),
      child: const Icon(LucideIcons.plus, size: 26),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String count;
  final VoidCallback? onTap;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.cardBorder),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: context.iconContainerBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 16, color: context.primaryAccent),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                  ),
                  Text(
                    count,
                    style: TextStyle(
                      fontSize: 10,
                      color: context.textSecondary,
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

class _RecentItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _RecentItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconBg = context.isDarkMode
        ? iconBg.withValues(alpha: 0.15)
        : iconBg;
    final effectiveIconColor = context.isDarkMode
        ? context.primaryAccent
        : iconColor;

    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.cardBorder),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: effectiveIconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: effectiveIconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: context.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  color: context.textSecondary,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final int selectedIndex;
  final void Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = selectedIndex == index;
    final activeColor = context.primaryAccent;
    const inactiveColor = Color(0xFF9CA3AF);

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 24,
              color: isActive ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardRecentItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final DateTime createdAt;
  final VoidCallback onTap;

  _DashboardRecentItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.createdAt,
    required this.onTap,
  });
}
