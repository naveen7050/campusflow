import 'package:flutter/foundation.dart';
import 'package:campusflow/features/questions/domain/models/question_model.dart';
import 'package:campusflow/features/questions/data/question_repository.dart';

class QuestionViewModel extends ChangeNotifier {
  final QuestionRepository _repository;

  QuestionViewModel({QuestionRepository? repository})
      : _repository = repository ?? QuestionRepository();

  List<QuestionModel> _questions = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  String _selectedFilter = 'all'; // 'all', 'starred', 'shared'
  String? _selectedSubjectId;
  String _searchQuery = '';

  List<QuestionModel> get questions => _questions;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  String get selectedFilter => _selectedFilter;
  String? get selectedSubjectId => _selectedSubjectId;
  String get searchQuery => _searchQuery;

  List<QuestionModel> get filteredQuestions {
    return _questions.where((q) {
      if (_selectedSubjectId != null && q.subjectId != _selectedSubjectId) {
        return false;
      }

      if (_selectedFilter == 'starred' && !q.isStarred) {
        return false;
      }
      if (_selectedFilter == 'shared' && !q.isShared) {
        return false;
      }

      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchQ = q.question.toLowerCase().contains(query);
        final matchA = q.answer?.toLowerCase().contains(query) ?? false;
        final matchSub = q.subjectName?.toLowerCase().contains(query) ?? false;
        if (!matchQ && !matchA && !matchSub) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void setFilter(String filter) {
    if (_selectedFilter != filter) {
      _selectedFilter = filter;
      notifyListeners();
    }
  }

  void setSubjectFilter(String? subjectId) {
    _selectedSubjectId = subjectId;
    fetchQuestions();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchQuestions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _questions = await _repository.getQuestions(
        subjectId: _selectedSubjectId,
        filter: _selectedFilter,
      );
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createQuestion({
    String? subjectId,
    required String question,
    String? answer,
    String? imageUrl,
    bool isStarred = false,
    bool isShared = false,
  }) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final created = await _repository.createQuestion(
        subjectId: subjectId,
        question: question,
        answer: answer,
        imageUrl: imageUrl,
        isStarred: isStarred,
        isShared: isShared,
      );
      _questions.insert(0, created);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> toggleStar(String id) async {
    try {
      final updated = await _repository.toggleStar(id);
      final index = _questions.indexWhere((q) => q.id == id);
      if (index != -1) {
        _questions[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleShare(QuestionModel question) async {
    _isSaving = true;
    notifyListeners();
    try {
      final updated = await _repository.updateQuestion(
        id: question.id,
        isShared: !question.isShared,
      );
      final index = _questions.indexWhere((q) => q.id == question.id);
      if (index != -1) {
        _questions[index] = updated;
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> deleteQuestion(String id) async {
    try {
      await _repository.deleteQuestion(id);
      _questions.removeWhere((q) => q.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
