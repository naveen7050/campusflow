import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../notes/presentation/viewmodels/note_viewmodel.dart';
import '../../materials/presentation/viewmodels/material_viewmodel.dart';
import '../../notes/presentation/views/notes_view.dart';
import '../../materials/presentation/views/materials_view.dart';

class SharedWithMeView extends StatefulWidget {
  static const String routeName = '/shared-with-me';
  final bool isTab;

  const SharedWithMeView({super.key, this.isTab = false});

  @override
  State<SharedWithMeView> createState() => _SharedWithMeViewState();
}

class _SharedWithMeViewState extends State<SharedWithMeView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTab = 'All'; // 'All', 'Notes', 'Questions', 'Material'

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteViewModel>().fetchNotes();
      context.read<MaterialViewModel>().fetchMaterials();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteVm = context.watch<NoteViewModel>();
    final materialVm = context.watch<MaterialViewModel>();

    final sharedNotes = noteVm.notes.where((n) => n.isShared).toList();
    final sharedMaterials =
        materialVm.materials.where((m) => m.isShared).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.isTab
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
                'Shared With Me',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 1024;
            final isTablet = constraints.maxWidth >= 600 && !isDesktop;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.isTab)
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: Text(
                          'Shared With Me',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2937),
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),

                    // Search Bar & Filter Tabs
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 46,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1F2937),
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Search shared resources...',
                                hintStyle: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF9CA3AF),
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Color(0xFF9CA3AF),
                                  size: 20,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Filter Tabs
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _SharedTab(
                                  label: 'All',
                                  isSelected: _selectedTab == 'All',
                                  onTap: () =>
                                      setState(() => _selectedTab = 'All'),
                                ),
                                const SizedBox(width: 8),
                                _SharedTab(
                                  label: 'Notes',
                                  isSelected: _selectedTab == 'Notes',
                                  onTap: () =>
                                      setState(() => _selectedTab = 'Notes'),
                                ),
                                const SizedBox(width: 8),
                                _SharedTab(
                                  label: 'Questions',
                                  isSelected: _selectedTab == 'Questions',
                                  onTap: () => setState(
                                      () => _selectedTab = 'Questions'),
                                ),
                                const SizedBox(width: 8),
                                _SharedTab(
                                  label: 'Material',
                                  isSelected: _selectedTab == 'Material',
                                  onTap: () => setState(
                                      () => _selectedTab = 'Material'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // List of Shared Content
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                        children: [
                          if (_selectedTab == 'All' ||
                              _selectedTab == 'Questions')
                            _SharedCard(
                              icon: Icons.quiz_outlined,
                              iconBg: const Color(0xFFEFF6FF),
                              iconColor: const Color(0xFF1E3A8A),
                              title: 'DSA Important Questions',
                              sharedBy: 'Shared by Riya',
                              timeAgo: '2 days ago',
                              onTap: () {},
                            ),
                          if (_selectedTab == 'All' || _selectedTab == 'Notes')
                            _SharedCard(
                              icon: Icons.notes_outlined,
                              iconBg: const Color(0xFFEBF5E9),
                              iconColor: const Color(0xFF0F5132),
                              title: 'DBMS Notes',
                              sharedBy: 'Shared by Aman',
                              timeAgo: '3 days ago',
                              onTap: () => Navigator.pushNamed(
                                context,
                                NotesView.routeName,
                              ),
                            ),
                          if (_selectedTab == 'All' ||
                              _selectedTab == 'Material')
                            _SharedCard(
                              icon: Icons.description_outlined,
                              iconBg: const Color(0xFFFFFBEB),
                              iconColor: const Color(0xFFD97706),
                              title: 'Java Cheat Sheet',
                              sharedBy: 'Shared by Tanvi',
                              timeAgo: '5 days ago',
                              onTap: () => Navigator.pushNamed(
                                context,
                                MaterialsView.routeName,
                              ),
                            ),

                          // Dynamic shared items from live database
                          for (final note in sharedNotes)
                            if (_selectedTab == 'All' ||
                                _selectedTab == 'Notes')
                              _SharedCard(
                                icon: Icons.notes_outlined,
                                iconBg: const Color(0xFFEBF5E9),
                                iconColor: const Color(0xFF0F5132),
                                title: note.title,
                                sharedBy: note.subjectName ?? 'Campus Peer',
                                timeAgo: 'Recently',
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  NotesView.routeName,
                                ),
                              ),
                          for (final mat in sharedMaterials)
                            if (_selectedTab == 'All' ||
                                _selectedTab == 'Material')
                              _SharedCard(
                                icon: Icons.folder_outlined,
                                iconBg: const Color(0xFFEFF6FF),
                                iconColor: const Color(0xFF1E3A8A),
                                title: mat.title,
                                sharedBy: mat.subjectName ?? 'Campus Peer',
                                timeAgo: 'Recently',
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  MaterialsView.routeName,
                                ),
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SharedTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SharedTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F5132) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF4B5563),
          ),
        ),
      ),
    );
  }
}

class _SharedCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String sharedBy;
  final String timeAgo;
  final VoidCallback onTap;

  const _SharedCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.sharedBy,
    required this.timeAgo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      sharedBy,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: Color(0xFF9CA3AF),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeAgo,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.chevron_right,
              color: Color(0xFF9CA3AF),
              size: 20,
            ),
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}
