import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campusflow/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:campusflow/features/auth/presentation/views/login_view.dart';
import 'package:campusflow/features/subjects/presentation/views/subjects_view.dart';
import 'package:campusflow/features/subjects/presentation/widgets/add_edit_subject_dialog.dart';
import 'add_content_view.dart';
import '../../notes/presentation/views/notes_view.dart';
import '../../materials/presentation/views/materials_view.dart';
import '../../questions/presentation/views/create_question_view.dart';
import '../../assignments/presentation/views/assignments_view.dart';
import '../../shared/presentation/views/shared_with_me_view.dart';
import '../../profile/presentation/views/profile_view.dart';

class HomeView extends StatefulWidget {
  static const String routeName = '/home';

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Future<void> _handleLogout(AuthViewModel authViewModel) async {
    await authViewModel.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, LoginView.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.user;
    final firstName = user?.fullName.split(' ').first ?? 'Student';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _selectedIndex == 0
            ? _buildHomeBody(authViewModel, user, firstName)
            : _buildPlaceholder(_selectedIndex),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildFab(authViewModel),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHomeBody(dynamic authViewModel, dynamic user, String firstName) {
    return CustomScrollView(
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
                        Icons.menu_book_rounded,
                        size: 20,
                        color: Color(0xFF0F5132),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'CampusFlow',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F5132),
                      ),
                    ),
                    const Spacer(),
                    // Notification
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none_outlined,
                        color: Color(0xFF1F2937),
                        size: 24,
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
                        backgroundColor: const Color(0xFF0F5132),
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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 14),

                // Search bar
                Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 14),
                      const Icon(
                        Icons.search,
                        color: Color(0xFF9CA3AF),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Search notes, questions, or files...',
                          style: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Quick stats
                Row(
                  children: [
                    _StatChip(
                      icon: Icons.quiz_outlined,
                      label: 'Questions',
                      count: '12 items',
                      onTap: () => Navigator.pushNamed(
                        context,
                        CreateQuestionView.routeName,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      icon: Icons.notes_outlined,
                      label: 'Notes',
                      count: '9 items',
                      onTap: () => Navigator.pushNamed(
                        context,
                        NotesView.routeName,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      icon: Icons.folder_outlined,
                      label: 'Materials',
                      count: '5 items',
                      onTap: () => Navigator.pushNamed(
                        context,
                        MaterialsView.routeName,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      icon: Icons.assignment_outlined,
                      label: 'Tasks',
                      count: '3 items',
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
                    const Text(
                      'Recent',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _selectedIndex = 1),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'View all >',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF0F5132),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Recent items
                _RecentItem(
                  icon: Icons.quiz_outlined,
                  iconBg: const Color(0xFFEBF5E9),
                  iconColor: const Color(0xFF0F5132),
                  title: 'DBMS Important Questions',
                  subtitle: 'Database Management Systems',
                  onTap: () => Navigator.pushNamed(
                    context,
                    CreateQuestionView.routeName,
                  ),
                ),
                const SizedBox(height: 10),
                _RecentItem(
                  icon: Icons.notes_outlined,
                  iconBg: const Color(0xFFEBF5E9),
                  iconColor: const Color(0xFF0F5132),
                  title: 'OOP Concepts Notes',
                  subtitle: 'Object Oriented Programming',
                  onTap: () => Navigator.pushNamed(
                    context,
                    NotesView.routeName,
                  ),
                ),
                const SizedBox(height: 10),
                _RecentItem(
                  icon: Icons.assignment_outlined,
                  iconBg: const Color(0xFFFFFBEB),
                  iconColor: const Color(0xFFD97706),
                  title: 'DBMS Assignment',
                  subtitle: 'Due: 12 Sep 2025 • Database Management',
                  onTap: () => Navigator.pushNamed(
                    context,
                    AssignmentsView.routeName,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
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
      color: Colors.white,
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
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: 'Home',
              index: 0,
              selectedIndex: _selectedIndex,
              onTap: (i) => setState(() => _selectedIndex = i),
            ),
            _NavItem(
              icon: Icons.explore_outlined,
              activeIcon: Icons.explore_rounded,
              label: 'Explore',
              index: 1,
              selectedIndex: _selectedIndex,
              onTap: (i) => setState(() => _selectedIndex = i),
            ),
            const SizedBox(width: 48), // Space for FAB
            _NavItem(
              icon: Icons.share_outlined,
              activeIcon: Icons.share_rounded,
              label: 'Shared',
              index: 3,
              selectedIndex: _selectedIndex,
              onTap: (i) => setState(() => _selectedIndex = i),
            ),
            _NavItem(
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
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
      backgroundColor: const Color(0xFF0F5132),
      foregroundColor: Colors.white,
      elevation: 4,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, size: 28),
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
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB)),
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
                      color: const Color(0xFFEBF5E9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 16, color: const Color(0xFF0F5132)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  Text(
                    count,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF6B7280),
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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
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
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF9CA3AF),
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
              color: isActive
                  ? const Color(0xFF0F5132)
                  : const Color(0xFF9CA3AF),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive
                    ? const Color(0xFF0F5132)
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
