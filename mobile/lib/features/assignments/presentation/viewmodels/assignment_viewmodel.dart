import 'package:flutter/foundation.dart';
import '../../domain/models/assignment_model.dart';
import '../../data/assignment_repository.dart';

class AssignmentViewModel extends ChangeNotifier {
  final AssignmentRepository _repository;

  AssignmentViewModel({AssignmentRepository? repository})
      : _repository = repository ?? AssignmentRepository();

  List<AssignmentModel> _assignments = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  String _selectedFilter = 'all'; // 'all', 'upcoming', 'completed'
  String? _selectedSubjectId;
  String _searchQuery = '';

  List<AssignmentModel> get assignments => _assignments;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  String get selectedFilter => _selectedFilter;
  String? get selectedSubjectId => _selectedSubjectId;
  String get searchQuery => _searchQuery;

  List<AssignmentModel> get filteredAssignments {
    return _assignments.where((item) {
      if (_selectedSubjectId != null && item.subjectId != _selectedSubjectId) {
        return false;
      }

      if (_selectedFilter == 'upcoming' && item.isSubmitted) {
        return false;
      }
      if (_selectedFilter == 'completed' && !item.isSubmitted) {
        return false;
      }

      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchTitle = item.title.toLowerCase().contains(query);
        final matchSubject = item.subjectName?.toLowerCase().contains(query) ?? false;
        final matchDesc = item.description?.toLowerCase().contains(query) ?? false;
        if (!matchTitle && !matchSubject && !matchDesc) {
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
    fetchAssignments();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchAssignments() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _assignments = await _repository.getAssignments(
        subjectId: _selectedSubjectId,
      );
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createAssignment({
    String? subjectId,
    required String title,
    String? description,
    DateTime? dueDate,
    bool isSubmitted = false,
  }) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final created = await _repository.createAssignment(
        subjectId: subjectId,
        title: title,
        description: description,
        dueDate: dueDate,
        isSubmitted: isSubmitted,
      );
      _assignments.insert(0, created);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> updateAssignment({
    required String id,
    String? subjectId,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isSubmitted,
  }) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _repository.updateAssignment(
        id: id,
        subjectId: subjectId,
        title: title,
        description: description,
        dueDate: dueDate,
        isSubmitted: isSubmitted,
      );
      final index = _assignments.indexWhere((item) => item.id == id);
      if (index != -1) {
        _assignments[index] = updated;
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

  Future<bool> toggleAssignment(String id) async {
    try {
      final updated = await _repository.toggleAssignment(id);
      final index = _assignments.indexWhere((item) => item.id == id);
      if (index != -1) {
        _assignments[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteAssignment(String id) async {
    try {
      await _repository.deleteAssignment(id);
      _assignments.removeWhere((item) => item.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
