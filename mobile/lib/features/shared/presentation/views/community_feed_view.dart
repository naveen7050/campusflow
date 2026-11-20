import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:campusflow/app/theme/app_colors.dart';
import 'package:campusflow/core/widgets/app_search_bar.dart';
import 'package:campusflow/core/widgets/app_background.dart';
import 'package:campusflow/features/notes/presentation/viewmodels/note_viewmodel.dart';
import 'package:campusflow/features/questions/presentation/viewmodels/question_viewmodel.dart';
import 'package:campusflow/features/materials/presentation/viewmodels/material_viewmodel.dart';
import 'package:campusflow/features/notes/presentation/views/create_note_view.dart';
import 'package:campusflow/features/questions/presentation/views/create_question_view.dart';
import 'package:campusflow/features/materials/presentation/widgets/add_material_dialog.dart';
import '../viewmodels/community_viewmodel.dart';
import '../widgets/community_question_card.dart';
import '../widgets/community_note_card.dart';
import '../widgets/community_material_card.dart';

class CommunityFeedView extends StatefulWidget {
  static const String routeName = '/community';
  final bool isTab;

  const CommunityFeedView({super.key, this.isTab = false});

  @override
  State<CommunityFeedView> createState() => _CommunityFeedViewState();
}

class _CommunityFeedViewState extends State<CommunityFeedView> {
  final _searchController = TextEditingController();
  late final CommunityViewModel _communityVm;

  @override
  void initState() {
    super.initState();
    // context.read is safe in initState (no subscription is created).
    _communityVm = CommunityViewModel(
      noteVm: context.read<NoteViewModel>(),
      questionVm: context.read<QuestionViewModel>(),
      materialVm: context.read<MaterialViewModel>(),
    );
    // Never trigger notifyListeners() while the tree is still building.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _communityVm.refreshAll();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _communityVm.dispose();
    super.dispose();
  }

  void _onSearch(String query) => _communityVm.setSearchQuery(query);

  Future<void> _onRefresh() => _communityVm.refreshAll();

  // ---------------------------------------------------------------------------
  // Bottom sheets
  // ---------------------------------------------------------------------------

  Widget _handle() => Center(
    child: Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: context.cardBorder,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );

  Widget _subjectBadge(String name) => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: context.iconContainerBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: context.primaryAccent,
        ),
      ),
    ),
  );

  Widget _authorRow(CommunityItem item) => Row(
    children: [
      Icon(LucideIcons.user, size: 14, color: context.textSecondary),
      const SizedBox(width: 6),
      Text(
        'Shared by ${item.authorName}',
        style: TextStyle(fontSize: 13, color: context.textSecondary),
      ),
    ],
  );

  void _showScrollableSheet({
    required double initialSize,
    required double maxSize,
    required List<Widget> Function() children,
  }) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: initialSize,
          minChildSize: 0.3,
          maxChildSize: maxSize,
          builder: (_, controller) {
            return ListView(
              controller: controller,
              padding: const EdgeInsets.all(24),
              children: children(),
            );
          },
        );
      },
    );
  }

  void _showSharePicker() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _handle(),
                const SizedBox(height: 16),
                Text(
                  'Share with Campus Peers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _ShareOption(
                  icon: LucideIcons.helpCircle,
                  iconBg: const Color(0xFFEFF6FF),
                  iconColor: const Color(0xFF1E3A8A),
                  title: 'Share Exam Question',
                  subtitle: 'Post viva or exam questions for peers',
                  onTap: () async {
                    Navigator.pop(ctx);
                    await Navigator.pushNamed(
                      context,
                      CreateQuestionView.routeName,
                    );
                    if (mounted) _onRefresh();
                  },
                ),
                const SizedBox(height: 8),
                _ShareOption(
                  icon: LucideIcons.fileText,
                  iconBg: const Color(0xFFEBF5E9),
                  iconColor: const Color(0xFF0F5132),
                  title: 'Share Revision Note',
                  subtitle: 'Publish revision notes for your batch',
                  onTap: () async {
                    Navigator.pop(ctx);
                    await Navigator.pushNamed(
                      context,
                      CreateNoteView.routeName,
                    );
                    if (mounted) _onRefresh();
                  },
                ),
                const SizedBox(height: 8),
                _ShareOption(
                  icon: LucideIcons.folder,
                  iconBg: const Color(0xFFFFFBEB),
                  iconColor: const Color(0xFFD97706),
                  title: 'Share PDF / Material',
                  subtitle: 'Upload shared PDFs or syllabus links',
                  onTap: () async {
                    Navigator.pop(ctx);
                    await AddMaterialDialog.show(context);
                    if (mounted) _onRefresh();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openQuestionDetail(CommunityItem item) {
    final hasAnswer = item.answer != null && item.answer!.isNotEmpty;
    final panelBg = context.isDarkMode
        ? const Color(0xFF1A1A1A)
        : const Color(0xFFF9FAFB);

    _showScrollableSheet(
      initialSize: 0.6,
      maxSize: 0.85,
      children: () => [
        _handle(),
        const SizedBox(height: 20),
        if (item.subjectName != null) _subjectBadge(item.subjectName!),
        const SizedBox(height: 14),
        Text(
          item.title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: context.textPrimary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        if (hasAnswer) ...[
          Text(
            'Answer',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: context.primaryAccent,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: panelBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.cardBorder),
            ),
            child: Text(
              item.answer!,
              style: TextStyle(
                fontSize: 14,
                color: context.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ] else
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.isDarkMode
                  ? const Color(0xFF1A1A1A)
                  : const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'No answer provided yet.',
              style: TextStyle(fontSize: 13, color: context.textSecondary),
            ),
          ),
        const SizedBox(height: 16),
        _authorRow(item),
      ],
    );
  }

  void _openNoteDetail(CommunityItem item) {
    final hasContent = item.content != null && item.content!.isNotEmpty;

    _showScrollableSheet(
      initialSize: 0.65,
      maxSize: 0.9,
      children: () => [
        _handle(),
        const SizedBox(height: 20),
        if (item.subjectName != null) _subjectBadge(item.subjectName!),
        const SizedBox(height: 14),
        Text(
          item.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: context.textPrimary,
          ),
        ),
        if (item.tags.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: item.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: context.isDarkMode
                      ? const Color(0xFF262626)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '#$tag',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: context.textSecondary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
        const SizedBox(height: 16),
        if (hasContent)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.isDarkMode
                  ? const Color(0xFF1A1A1A)
                  : const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.cardBorder),
            ),
            child: Text(
              item.content!,
              style: TextStyle(
                fontSize: 14,
                color: context.textPrimary,
                height: 1.6,
              ),
            ),
          ),
        const SizedBox(height: 16),
        _authorRow(item),
      ],
    );
  }

  void _openMaterialDetail(CommunityItem item) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _handle(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: context.isDarkMode
                            ? const Color(0xFFD97706).withValues(alpha: 0.15)
                            : const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        LucideIcons.fileText,
                        size: 24,
                        color: context.isDarkMode
                            ? const Color(0xFFFBBF24)
                            : const Color(0xFFD97706),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: context.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${item.fileType ?? "PDF"} • ${item.fileSize ?? "Unknown size"}',
                            style: TextStyle(
                              fontSize: 12,
                              color: context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (item.subjectName != null) ...[
                  Row(
                    children: [
                      Icon(
                        LucideIcons.bookOpen,
                        size: 14,
                        color: context.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.subjectName!,
                        style: TextStyle(
                          fontSize: 13,
                          color: context.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                _authorRow(item),
                const SizedBox(height: 20),
                if (item.fileUrl != null && item.fileUrl!.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final uri = Uri.tryParse(item.fileUrl!);
                        if (uri != null && await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      icon: const Icon(LucideIcons.externalLink, size: 16),
                      label: const Text('Open Document'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.primaryAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Rebuild when the underlying data view models change.
    context.watch<NoteViewModel>();
    context.watch<QuestionViewModel>();
    context.watch<MaterialViewModel>();

    final isDark = context.isDarkMode;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final titleColor = isDark ? Colors.white : const Color(0xFF1F2937);

    final content = AppBackground(
      child: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF0F5132),
          onRefresh: _onRefresh,
          // Rebuilds on tab / search / refreshing changes only.
          child: ListenableBuilder(
            listenable: _communityVm,
            builder: (context, _) {
              final items = _communityVm.filteredItems;
              final isLoading = _communityVm.isRefreshing && items.isEmpty;

              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    sliver: SliverToBoxAdapter(child: _buildHeader()),
                  ),
                  if (isLoading)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 60),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF0F5132),
                          ),
                        ),
                      ),
                    )
                  else if (items.isEmpty)
                    SliverToBoxAdapter(child: _buildEmptyState(isDark))
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildItemCard(items[index]),
                          childCount: items.length,
                        ),
                      ),
                    ),
                  // Space for the bottom navigation bar.
                  const SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              );
            },
          ),
        ),
      ),
    );

    if (widget.isTab) return content;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
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
          'Community',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.share2, color: context.primaryAccent),
            tooltip: 'Share Content',
            onPressed: _showSharePicker,
          ),
        ],
      ),
      body: content,
    );
  }

  Widget _buildHeader() {
    const tabs = ['All', 'Questions', 'Notes', 'Materials'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isTab) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Community',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showSharePicker,
                icon: const Icon(LucideIcons.share2, size: 16),
                label: const Text('Share'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryAccent,
                  foregroundColor: Colors.white,
                  // Override any theme-level Size(double.infinity, ...) so the
                  // button can live inside a Row.
                  minimumSize: const Size(0, 38),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        AppSearchBar(
          controller: _searchController,
          hintText: 'Search shared resources...',
          onChanged: _onSearch,
          onClear: () {
            _searchController.clear();
            _onSearch('');
          },
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < tabs.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                _TabChip(
                  label: tabs[i],
                  isSelected: _communityVm.selectedTab == tabs[i],
                  onTap: () => _communityVm.setTab(tabs[i]),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget _buildItemCard(CommunityItem item) {
    switch (item.category) {
      case 'Questions':
        return CommunityQuestionCard(
          item: item,
          onTap: () => _openQuestionDetail(item),
        );
      case 'Notes':
        return CommunityNoteCard(
          item: item,
          onTap: () => _openNoteDetail(item),
        );
      case 'Materials':
        return CommunityMaterialCard(
          item: item,
          onTap: () => _openMaterialDetail(item),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildEmptyState(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E3A2B) : const Color(0xFFEBF5E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.share2,
              size: 32,
              color: Color(0xFF0F5132),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No shared resources yet',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to share exam questions, notes, or study materials with your campus.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: context.textSecondary),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _showSharePicker,
            icon: const Icon(LucideIcons.share2, size: 16),
            label: const Text('Share a Resource'),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primaryAccent,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private widgets
// ---------------------------------------------------------------------------

class _TabChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabChip({
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
          color: isSelected ? context.primaryAccent : context.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? context.primaryAccent : context.cardBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : context.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _ShareOption extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: context.isDarkMode
              ? iconColor.withValues(alpha: 0.15)
              : iconBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: Icon(
        LucideIcons.chevronRight,
        size: 18,
        color: context.textSecondary,
      ),
      onTap: onTap,
    );
  }
}
