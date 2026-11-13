import 'package:flutter/material.dart';

class CategoryBottomSheet extends StatefulWidget {
  final List<String> categories;
  final String? initialSelected;

  const CategoryBottomSheet({
    super.key,
    required this.categories,
    this.initialSelected,
  });

  static Future<String?> show(
    BuildContext context, {
    required List<String> categories,
    String? initialSelected,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CategoryBottomSheet(
        categories: categories,
        initialSelected: initialSelected,
      ),
    );
  }

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  late String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelected ??
        (widget.categories.isNotEmpty ? widget.categories.first : null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Header (Matches Screen 20)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  color: const Color(0xFF1F2937),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Select Category',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // List of Categories
            for (final cat in widget.categories)
              InkWell(
                onTap: () => setState(() => _selected = cat),
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 6,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _selected == cat
                                ? const Color(0xFF0F5132)
                                : const Color(0xFFD1D5DB),
                            width: 2,
                          ),
                        ),
                        child: _selected == cat
                            ? Center(
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF0F5132),
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 14),
                      Text(
                        cat,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: _selected == cat
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Done Button
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, _selected),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5132),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

