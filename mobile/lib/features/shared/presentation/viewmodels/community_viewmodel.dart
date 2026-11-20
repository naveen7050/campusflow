import 'package:flutter/foundation.dart';
import 'package:campusflow/features/notes/domain/models/note_model.dart';
import 'package:campusflow/features/questions/domain/models/question_model.dart';
import 'package:campusflow/features/materials/domain/models/material_model.dart';
import 'package:campusflow/features/notes/presentation/viewmodels/note_viewmodel.dart';
import 'package:campusflow/features/questions/presentation/viewmodels/question_viewmodel.dart';
import 'package:campusflow/features/materials/presentation/viewmodels/material_viewmodel.dart';

/// Unified item that wraps a note, question, or material for the community feed.
class CommunityItem {
  final String id;
  final String category; // 'Notes', 'Questions', 'Materials'
  final String title;
  final String authorName;
  final String? subjectName;
  final String? subjectCode;
  final DateTime? createdAt;

  // Note-specific
  final String? content;
  final List<String> tags;

  // Question-specific
  final String? answer;
  final String? imageUrl;

  // Material-specific
  final String? fileUrl;
  final String? fileType;
  final String? fileSize;

  const CommunityItem({
    required this.id,
    required this.category,
    required this.title,
    required this.authorName,
    this.subjectName,
    this.subjectCode,
    this.createdAt,
    this.content,
    this.tags = const [],
    this.answer,
    this.imageUrl,
    this.fileUrl,
    this.fileType,
    this.fileSize,
  });

  static String _author(String? name) =>
      (name != null && name.isNotEmpty) ? name : 'Campus Peer';

  factory CommunityItem.fromNote(NoteModel n) => CommunityItem(
        id: n.id,
        category: 'Notes',
        title: n.title,
        authorName: _author(n.authorName),
        subjectName: n.subjectName,
        subjectCode: n.subjectCode,
        createdAt: n.createdAt,
        content: n.content,
        tags: n.tags,
      );

  factory CommunityItem.fromQuestion(QuestionModel q) => CommunityItem(
        id: q.id,
        category: 'Questions',
        title: q.question,
        authorName: _author(q.authorName),
        subjectName: q.subjectName,
        subjectCode: q.subjectCode,
        createdAt: q.createdAt,
        answer: q.answer,
        imageUrl: q.imageUrl,
      );

  factory CommunityItem.fromMaterial(MaterialModel m) => CommunityItem(
        id: m.id,
        category: 'Materials',
        title: m.title,
        authorName: _author(m.authorName),
        subjectName: m.subjectName,
        subjectCode: m.subjectCode,
        createdAt: m.createdAt,
        fileUrl: m.fileUrl,
        fileType: m.fileType,
        fileSize: m.fileSize,
      );
}

/// View model that aggregates shared items from notes, questions, and materials.
class CommunityViewModel extends ChangeNotifier {
  final NoteViewModel _noteVm;
  final QuestionViewModel _questionVm;
  final MaterialViewModel _materialVm;

  CommunityViewModel({
    required NoteViewModel noteVm,
    required QuestionViewModel questionVm,
    required MaterialViewModel materialVm,
  })  : _noteVm = noteVm,
        _questionVm = questionVm,
        _materialVm = materialVm;

  String _selectedTab = 'All'; // 'All', 'Questions', 'Notes', 'Materials'
  String _searchQuery = '';
  bool _isRefreshing = false;
  bool _disposed = false;

  String get selectedTab => _selectedTab;
  String get searchQuery => _searchQuery;
  bool get isRefreshing => _isRefreshing;

  // Guards against "notifyListeners() called after dispose()" when the user
  // leaves the screen while a fetch is still in flight.
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  void setTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Fetches all shared items from the backend.
  Future<void> refreshAll() async {
    _isRefreshing = true;
    notifyListeners();
    try {
      await Future.wait([
        _noteVm.fetchNotes(subjectId: '', filter: 'shared'),
        _questionVm.fetchQuestions(subjectId: '', filter: 'shared'),
        _materialVm.fetchMaterials(subjectId: '', filter: 'shared'),
      ]);
    } catch (e, st) {
      // Keep the existing feed, but don't hide the reason it failed.
      debugPrint('Community refresh failed: $e\n$st');
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  /// Returns a merged and sorted (newest first) list of community items.
  List<CommunityItem> get items {
    final all = <CommunityItem>[];

    for (final n in _noteVm.notes.where((n) => n.isShared)) {
      all.add(CommunityItem.fromNote(n));
    }
    for (final q in _questionVm.questions.where((q) => q.isShared)) {
      all.add(CommunityItem.fromQuestion(q));
    }
    for (final m in _materialVm.materials.where((m) => m.isShared)) {
      all.add(CommunityItem.fromMaterial(m));
    }

    final epoch = DateTime.fromMillisecondsSinceEpoch(0);
    all.sort((a, b) =>
        (b.createdAt ?? epoch).compareTo(a.createdAt ?? epoch));

    return all;
  }

  /// Returns items filtered by selected tab and search query.
  List<CommunityItem> get filteredItems {
    final query = _searchQuery.trim().toLowerCase();
    return items.where((item) {
      final matchesTab = _selectedTab == 'All' || item.category == _selectedTab;
      final matchesSearch = query.isEmpty ||
          item.title.toLowerCase().contains(query) ||
          item.authorName.toLowerCase().contains(query) ||
          (item.subjectName?.toLowerCase().contains(query) ?? false);
      return matchesTab && matchesSearch;
    }).toList();
  }
}