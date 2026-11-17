import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:campusflow/core/widgets/app_network_or_memory_image.dart';
import 'package:campusflow/features/notes/presentation/viewmodels/note_viewmodel.dart';
import 'package:campusflow/features/materials/presentation/viewmodels/material_viewmodel.dart';
import 'package:campusflow/features/questions/presentation/viewmodels/question_viewmodel.dart';
import 'package:campusflow/features/notes/presentation/views/create_note_view.dart';
import 'package:campusflow/features/materials/presentation/widgets/add_material_dialog.dart';
import 'package:campusflow/features/questions/presentation/views/create_question_view.dart';

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
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshSharedData();
    });
  }

  Future<void> _refreshSharedData() async {
    if (!mounted) return;
    setState(() => _isRefreshing = true);
    try {
      await Future.wait([
        context.read<NoteViewModel>().fetchNotes(filter: 'all'),
        context.read<MaterialViewModel>().fetchMaterials(filter: 'all'),
        context.read<QuestionViewModel>().fetchQuestions(filter: 'all'),
      ]);
    } catch (_) {
      // Ignore network errors on refresh and keep existing UI
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatTimeAgo(DateTime? date) {
    if (date == null) return 'Recently';
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} mo ago';
    if (diff.inDays > 0) return '${diff.inDays} d ago';
    if (diff.inHours > 0) return '${diff.inHours} h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes} m ago';
    return 'Just now';
  }

  void _showSharePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.white,
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
                const SizedBox(height: 16),
                const Text(
                  'Share with Campus Peers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      LucideIcons.fileText,
                      color: Color(0xFF2E7D32),
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Share a Note',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Publish revision notes to your batch',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(
                    LucideIcons.chevronRight,
                    size: 18,
                    color: Color(0xFF9CA3AF),
                  ),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await Navigator.pushNamed(context, CreateNoteView.routeName);
                    _refreshSharedData();
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      LucideIcons.folder,
                      color: Color(0xFF1E3A8A),
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Share Study Material',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Upload shared PDFs or syllabus links',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(
                    LucideIcons.chevronRight,
                    size: 18,
                    color: Color(0xFF9CA3AF),
                  ),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await AddMaterialDialog.show(context);
                    _refreshSharedData();
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBF5E9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      LucideIcons.helpCircle,
                      color: Color(0xFF0F5132),
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Share a Question',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Post practice exam questions & answers',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(
                    LucideIcons.chevronRight,
                    size: 18,
                    color: Color(0xFF9CA3AF),
                  ),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await Navigator.pushNamed(context, CreateQuestionView.routeName);
                    _refreshSharedData();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showNoteDetail(
    BuildContext context, {
    required String title,
    required String author,
    String? subject,
    required String content,
    List<String> tags = const [],
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF5E9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Note',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F5132),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (subject != null)
                        Text(
                          subject,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Shared by $author',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  if (tags.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: tags
                          .map((t) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '#$t',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF4B5563),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Text(
                      content.isEmpty ? 'No additional content provided.' : content,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF374151),
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: content));
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Note copied to clipboard!')),
                            );
                          },
                          icon: const Icon(LucideIcons.fileText, size: 16),
                          label: const Text('Copy Content'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0F5132),
                            side: const BorderSide(color: Color(0xFF0F5132)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F5132),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Done'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showQuestionDetail(
    BuildContext context, {
    required String question,
    String? answer,
    required String author,
    String? subject,
    String? imageUrl,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Question',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (subject != null)
                        Text(
                          subject,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Question:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    question,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2937),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Shared by $author',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  if (imageUrl != null && imageUrl.trim().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AppNetworkOrMemoryImage(
                        imageUrl: imageUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  const Text(
                    'Answer / Explanation:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F5132),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBF5E9).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFC7E2C6)),
                    ),
                    child: Text(
                      (answer != null && answer.trim().isNotEmpty)
                          ? answer
                          : 'No explanation provided yet.',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1F2937),
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F5132),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showMaterialDetail(
    BuildContext context, {
    required String title,
    required String author,
    String? subject,
    required String fileType,
    required String fileSize,
    String? fileUrl,
  }) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        fileType.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFD97706),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      fileSize,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                    ),
                    const Spacer(),
                    if (subject != null)
                      Text(
                        subject,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Shared by $author',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 16),
                if (fileUrl != null && fileUrl.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.link, size: 16, color: Color(0xFF0F5132)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            fileUrl,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1E3A8A),
                              decoration: TextDecoration.underline,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    if (fileUrl != null && fileUrl.isNotEmpty) ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: fileUrl));
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Link copied to clipboard!')),
                            );
                          },
                          icon: const Icon(LucideIcons.link, size: 16),
                          label: const Text('Copy Link'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF0F5132),
                            side: const BorderSide(color: Color(0xFF0F5132)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F5132),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteVm = context.watch<NoteViewModel>();
    final materialVm = context.watch<MaterialViewModel>();
    final questionVm = context.watch<QuestionViewModel>();

    final items = <_SharedDisplayItem>[];

    // Shared Notes from backend
    for (final note in noteVm.notes.where((n) => n.isShared)) {
      items.add(_SharedDisplayItem(
        title: note.title,
        sharedBy: 'Shared by ${note.authorName ?? note.subjectName ?? 'Campus Peer'}',
        category: 'Notes',
        createdAt: note.createdAt,
        icon: LucideIcons.fileText,
        iconBg: const Color(0xFFEBF5E9),
        iconColor: const Color(0xFF0F5132),
        onTap: () => _showNoteDetail(
          context,
          title: note.title,
          author: note.authorName ?? 'Campus Peer',
          subject: note.subjectName,
          content: note.content,
          tags: note.tags,
        ),
      ));
    }

    // Shared Questions from backend
    for (final q in questionVm.questions.where((q) => q.isShared)) {
      items.add(_SharedDisplayItem(
        title: q.question,
        sharedBy: 'Shared by ${q.authorName ?? q.subjectName ?? 'Campus Peer'}',
        category: 'Questions',
        createdAt: q.createdAt,
        icon: LucideIcons.helpCircle,
        iconBg: const Color(0xFFEFF6FF),
        iconColor: const Color(0xFF1E3A8A),
        onTap: () => _showQuestionDetail(
          context,
          question: q.question,
          answer: q.answer,
          author: q.authorName ?? 'Campus Peer',
          subject: q.subjectName,
          imageUrl: q.imageUrl,
        ),
      ));
    }

    // Shared Materials from backend
    for (final mat in materialVm.materials.where((m) => m.isShared)) {
      items.add(_SharedDisplayItem(
        title: mat.title,
        sharedBy: 'Shared by ${mat.authorName ?? mat.subjectName ?? 'Campus Peer'}',
        category: 'Material',
        createdAt: mat.createdAt,
        icon: LucideIcons.folder,
        iconBg: const Color(0xFFFFFBEB),
        iconColor: const Color(0xFFD97706),
        onTap: () => _showMaterialDetail(
          context,
          title: mat.title,
          author: mat.authorName ?? 'Campus Peer',
          subject: mat.subjectName,
          fileType: mat.fileType,
          fileSize: mat.fileSize,
          fileUrl: mat.fileUrl,
        ),
      ));
    }

    // If server has no shared resources yet, add curated campus community sample items
    if (items.isEmpty) {
      items.addAll([
        _SharedDisplayItem(
          title: 'Data Structures: Tree Traversals & BST Summary',
          sharedBy: 'Shared by Prof. Sharma • CS201',
          category: 'Notes',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          icon: LucideIcons.fileText,
          iconBg: const Color(0xFFEBF5E9),
          iconColor: const Color(0xFF0F5132),
          onTap: () => _showNoteDetail(
            context,
            title: 'Data Structures: Tree Traversals & BST Summary',
            author: 'Prof. Sharma',
            subject: 'Data Structures (CS201)',
            content: 'Key binary search tree operations:\n• Inorder traversal of BST gives keys in sorted order.\n• Search complexity: Average O(log n), Worst O(n).\n• Insertion & Deletion require pointer adjustments.\n• Balancing is maintained in AVL & Red-Black trees.',
            tags: ['DSA', 'Trees', 'Unit2'],
          ),
        ),
        _SharedDisplayItem(
          title: 'DBMS Past Midterm Exam Questions & Solutions',
          sharedBy: 'Shared by Rahul Verma • CS202',
          category: 'Questions',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          icon: LucideIcons.helpCircle,
          iconBg: const Color(0xFFEFF6FF),
          iconColor: const Color(0xFF1E3A8A),
          onTap: () => _showQuestionDetail(
            context,
            question: 'What is the difference between 3NF and BCNF? Provide an example.',
            answer: 'A relation is in 3NF if for every non-trivial functional dependency X -> Y, either X is a superkey or Y is a prime attribute. BCNF requires that X MUST be a superkey for every non-trivial FD. BCNF is strictly stronger than 3NF.',
            author: 'Rahul Verma',
            subject: 'Database Management Systems (CS202)',
          ),
        ),
        _SharedDisplayItem(
          title: 'Operating Systems: CPU Scheduling Algorithms PDF',
          sharedBy: 'Shared by Campus Academic Council • CS301',
          category: 'Material',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          icon: LucideIcons.folder,
          iconBg: const Color(0xFFFFFBEB),
          iconColor: const Color(0xFFD97706),
          onTap: () => _showMaterialDetail(
            context,
            title: 'Operating Systems: CPU Scheduling Algorithms PDF',
            author: 'Campus Academic Council',
            subject: 'Operating Systems (CS301)',
            fileType: 'PDF',
            fileSize: '3.4 MB',
            fileUrl: 'https://campusflow.internal/os-scheduling-notes.pdf',
          ),
        ),
        _SharedDisplayItem(
          title: 'Top 30 Computer Networks Viva Questions',
          sharedBy: 'Shared by Ananya Roy • CS304',
          category: 'Questions',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          icon: LucideIcons.helpCircle,
          iconBg: const Color(0xFFEFF6FF),
          iconColor: const Color(0xFF1E3A8A),
          onTap: () => _showQuestionDetail(
            context,
            question: 'Explain the 3-Way Handshake in TCP connection establishment.',
            answer: 'Step 1: Client sends SYN packet to Server.\nStep 2: Server responds with SYN-ACK packet.\nStep 3: Client sends ACK packet back to Server. Connection is now established.',
            author: 'Ananya Roy',
            subject: 'Computer Networks (CS304)',
          ),
        ),
      ]);
    }

    // Sort newest first
    items.sort((a, b) {
      final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });

    // Apply Filter & Search
    final query = _searchController.text.trim().toLowerCase();
    final filteredItems = items.where((item) {
      final matchesTab = _selectedTab == 'All' || item.category == _selectedTab;
      final matchesSearch = query.isEmpty ||
          item.title.toLowerCase().contains(query) ||
          item.sharedBy.toLowerCase().contains(query);
      return matchesTab && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.isTab
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
                'Shared With Me',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.share2, color: Color(0xFF0F5132)),
                  tooltip: 'Share Content',
                  onPressed: () => _showSharePicker(context),
                ),
              ],
            ),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF0F5132),
          onRefresh: _refreshSharedData,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (widget.isTab)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Shared With Me',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1F2937),
                                  letterSpacing: -0.3,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _showSharePicker(context),
                                icon: const Icon(LucideIcons.share2, size: 16),
                                label: const Text('Share'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0F5132),
                                  foregroundColor: Colors.white,
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
                                    LucideIcons.search,
                                    color: Color(0xFF9CA3AF),
                                    size: 18,
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
                                    onTap: () => setState(() => _selectedTab = 'All'),
                                  ),
                                  const SizedBox(width: 8),
                                  _SharedTab(
                                    label: 'Notes',
                                    isSelected: _selectedTab == 'Notes',
                                    onTap: () => setState(() => _selectedTab = 'Notes'),
                                  ),
                                  const SizedBox(width: 8),
                                  _SharedTab(
                                    label: 'Questions',
                                    isSelected: _selectedTab == 'Questions',
                                    onTap: () => setState(() => _selectedTab = 'Questions'),
                                  ),
                                  const SizedBox(width: 8),
                                  _SharedTab(
                                    label: 'Material',
                                    isSelected: _selectedTab == 'Material',
                                    onTap: () => setState(() => _selectedTab = 'Material'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // List of Shared Content
                      Expanded(
                        child: _isRefreshing && items.isEmpty
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF0F5132),
                                ),
                              )
                            : filteredItems.isEmpty
                                ? ListView(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 64,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 72,
                                              height: 72,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFEBF5E9),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                LucideIcons.share2,
                                                size: 32,
                                                color: Color(0xFF0F5132),
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            const Text(
                                              'No matching resources found',
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF1F2937),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              'Try a different search term or share a new resource with your batch.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFF6B7280),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            ElevatedButton.icon(
                                              onPressed: () => _showSharePicker(context),
                                              icon: const Icon(LucideIcons.share2, size: 16),
                                              label: const Text('Share a Resource'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFF0F5132),
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : ListView.builder(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                                    itemCount: filteredItems.length,
                                    itemBuilder: (context, index) {
                                      final item = filteredItems[index];
                                      return _SharedCard(
                                        icon: item.icon,
                                        iconBg: item.iconBg,
                                        iconColor: item.iconColor,
                                        title: item.title,
                                        sharedBy: item.sharedBy,
                                        timeAgo: _formatTimeAgo(item.createdAt),
                                        onTap: item.onTap,
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SharedDisplayItem {
  final String title;
  final String sharedBy;
  final String category;
  final DateTime? createdAt;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback onTap;

  _SharedDisplayItem({
    required this.title,
    required this.sharedBy,
    required this.category,
    this.createdAt,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
  });
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
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
                      Flexible(
                        child: Text(
                          sharedBy,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
            const Icon(
              LucideIcons.chevronRight,
              color: Color(0xFF9CA3AF),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
