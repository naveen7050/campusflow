import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/material_viewmodel.dart';
import '../widgets/add_material_dialog.dart';

class MaterialsView extends StatefulWidget {
  static const String routeName = '/materials';

  final String? subjectId;
  final String? subjectName;

  const MaterialsView({super.key, this.subjectId, this.subjectName});

  @override
  State<MaterialsView> createState() => _MaterialsViewState();
}

class _MaterialsViewState extends State<MaterialsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<MaterialViewModel>();
      if (widget.subjectId != null) {
        vm.setSubjectFilter(widget.subjectId);
      } else {
        vm.fetchMaterials();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return 'Recently';
    final diff = DateTime.now().difference(dt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} weeks ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MaterialViewModel>();
    final materials = vm.filteredMaterials;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                color: const Color(0xFF1F2937),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          widget.subjectName != null
              ? '${widget.subjectName} Materials'
              : 'Study Material',
          style: const TextStyle(
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
                  children: [
                    // Search & Tabs
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: Column(
                        children: [
                          // Search bar
                          Container(
                            height: 46,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (q) => vm.setSearchQuery(q),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1F2937),
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    'Search files, documents, or subjects...',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 13,
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Color(0xFF9CA3AF),
                                  size: 20,
                                ),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear, size: 18),
                                        onPressed: () {
                                          _searchController.clear();
                                          vm.setSearchQuery('');
                                        },
                                      )
                                    : null,
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Pill Tabs (All, My Files, Shared)
                          Row(
                            children: [
                              _PillTab(
                                label: 'All',
                                isSelected: vm.selectedFilter == 'all',
                                onTap: () => vm.setFilter('all'),
                              ),
                              const SizedBox(width: 8),
                              _PillTab(
                                label: 'My Files',
                                isSelected: vm.selectedFilter == 'my',
                                onTap: () => vm.setFilter('my'),
                              ),
                              const SizedBox(width: 8),
                              _PillTab(
                                label: 'Shared',
                                isSelected: vm.selectedFilter == 'shared',
                                onTap: () => vm.setFilter('shared'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Material List
                    Expanded(
                      child: _buildBody(
                        vm,
                        materials,
                        isTablet: isTablet,
                        isDesktop: isDesktop,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddMaterialDialog.show(
            context,
            initialSubjectId: widget.subjectId,
          );
        },
        backgroundColor: const Color(0xFF0F5132),
        foregroundColor: Colors.white,
        elevation: 3,
        tooltip: 'Upload Material',
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildBody(
    MaterialViewModel vm,
    List materials, {
    required bool isTablet,
    required bool isDesktop,
  }) {
    if (vm.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF0F5132)),
      );
    }

    if (vm.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Color(0xFFEF4444),
              ),
              const SizedBox(height: 12),
              const Text(
                'Could not load materials',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                vm.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => vm.fetchMaterials(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5132),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (materials.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.folder_open_rounded,
                  size: 56,
                  color: Color(0xFF1E3A8A),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'No materials yet!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Upload PDFs, lecture slides, and reference links to organize your study library.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  AddMaterialDialog.show(
                    context,
                    initialSubjectId: widget.subjectId,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5132),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text('+ Upload Material'),
              ),
            ],
          ),
        ),
      );
    }

    if (isDesktop || isTablet) {
      final crossAxisCount = isDesktop ? 3 : 2;
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 2.8,
        ),
        itemCount: materials.length,
        itemBuilder: (context, index) {
          final mat = materials[index];
          return _MaterialCard(
            material: mat,
            dateStr: _formatDate(mat.updatedAt),
          );
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: materials.length,
      itemBuilder: (context, index) {
        final mat = materials[index];
        return _MaterialCard(
          material: mat,
          dateStr: _formatDate(mat.updatedAt),
        );
      },
    );
  }
}

class _MaterialCard extends StatelessWidget {
  final dynamic material;
  final String dateStr;

  const _MaterialCard({
    required this.material,
    required this.dateStr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opening ${material.title}...')),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Red PDF / Material Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf_outlined,
                    size: 22,
                    color: Color(0xFFDC2626),
                  ),
                ),
                const SizedBox(width: 14),
                // Title & Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        material.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2937),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            '${material.fileType} • ${material.fileSize}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          if (material.subjectName != null) ...[
                            const Text(
                              ' • ',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                            Text(
                              material.subjectName!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF0F5132),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        material.isShared
                            ? Icons.share_rounded
                            : Icons.share_outlined,
                        color: material.isShared
                            ? const Color(0xFF0F5132)
                            : const Color(0xFF9CA3AF),
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: material.isShared
                          ? 'Shared with peers'
                          : 'Share with peers',
                      onPressed: () async {
                        final vm = context.read<MaterialViewModel>();
                        final ok = await vm.toggleShare(material);
                        if (ok && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                material.isShared
                                    ? 'Material made private'
                                    : 'Material shared with campus peers!',
                              ),
                              backgroundColor: const Color(0xFF0F5132),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 6),
                    Text(
                      dateStr,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PillTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PillTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F5132) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF4B5563),
          ),
        ),
      ),
    );
  }
}

