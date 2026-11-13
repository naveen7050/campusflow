import 'package:flutter/material.dart';
import '../../data/note_repository.dart';
import '../../domain/models/note_model.dart';

class NoteViewModel extends ChangeNotifier {
  final NoteRepository _repository;

  NoteViewModel({NoteRepository? repository})
      : _repository = repository ?? NoteRepository();

  List<NoteModel> _notes = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  String _selectedFilter = 'all'; // 'all', 'my', 'shared'
  String _searchQuery = '';
  String? _selectedSubjectId;

  List<NoteModel> get notes => _notes;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  String get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;
  String? get selectedSubjectId => _selectedSubjectId;

  List<NoteModel> get filteredNotes {
    return _notes.where((note) {
      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query) ||
          (note.subjectName?.toLowerCase().contains(query) ?? false);

      final matchesSubject = _selectedSubjectId == null ||
          note.subjectId == _selectedSubjectId;

      return matchesSearch && matchesSubject;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    fetchNotes(subjectId: _selectedSubjectId, filter: filter);
  }

  void setSubjectFilter(String? subjectId) {
    _selectedSubjectId = subjectId;
    fetchNotes(subjectId: subjectId, filter: _selectedFilter);
  }

  Future<void> fetchNotes({String? subjectId, String? filter}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notes = await _repository.getNotes(
        subjectId: subjectId ?? _selectedSubjectId,
        filter: filter ?? _selectedFilter,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createNote({
    String? subjectId,
    required String title,
    String content = '',
    List<String> tags = const [],
    bool isShared = false,
  }) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newNote = await _repository.createNote(
        subjectId: subjectId,
        title: title,
        content: content,
        tags: tags,
        isShared: isShared,
      );
      _notes.insert(0, newNote);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> updateNote({
    required String id,
    String? subjectId,
    String? title,
    String? content,
    List<String>? tags,
    bool? isShared,
  }) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _repository.updateNote(
        id: id,
        subjectId: subjectId,
        title: title,
        content: content,
        tags: tags,
        isShared: isShared,
      );

      final index = _notes.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notes[index] = updated;
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> toggleShare(NoteModel note) async {
    return updateNote(
      id: note.id,
      isShared: !note.isShared,
    );
  }

  Future<bool> deleteNote(String id) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteNote(id);
      _notes.removeWhere((n) => n.id == id);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}

