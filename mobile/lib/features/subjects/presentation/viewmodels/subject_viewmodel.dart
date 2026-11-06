import 'package:flutter/material.dart';
import '../../data/subject_repository.dart';
import '../../domain/models/subject_model.dart';

class SubjectViewModel extends ChangeNotifier {
  final SubjectRepository _repository;

  SubjectViewModel({SubjectRepository? repository})
      : _repository = repository ?? SubjectRepository();

  List<SubjectModel> _subjects = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  String _searchQuery = '';
  int? _selectedSemester;

  List<SubjectModel> get subjects => _subjects;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  int? get selectedSemester => _selectedSemester;

  List<SubjectModel> get filteredSubjects {
    return _subjects.where((subject) {
      final matchesSemester = _selectedSemester == null ||
          subject.semester == _selectedSemester;

      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          subject.name.toLowerCase().contains(query) ||
          (subject.code?.toLowerCase().contains(query) ?? false) ||
          (subject.department?.toLowerCase().contains(query) ?? false);

      return matchesSemester && matchesSearch;
    }).toList();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSemesterFilter(int? semester) {
    _selectedSemester = semester;
    notifyListeners();
  }

  Future<void> fetchSubjects() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _subjects = await _repository.getSubjects();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createSubject({
    required String name,
    String? code,
    String? description,
    int? semester,
    String? department,
    String color = '#0F5132',
    String icon = 'menu_book',
  }) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newSubject = await _repository.createSubject(
        name: name,
        code: code,
        description: description,
        semester: semester,
        department: department,
        color: color,
        icon: icon,
      );

      _subjects.insert(0, newSubject);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> updateSubject({
    required String id,
    String? name,
    String? code,
    String? description,
    int? semester,
    String? department,
    String? color,
    String? icon,
  }) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _repository.updateSubject(
        id: id,
        name: name,
        code: code,
        description: description,
        semester: semester,
        department: department,
        color: color,
        icon: icon,
      );

      final index = _subjects.indexWhere((s) => s.id == id);
      if (index != -1) {
        _subjects[index] = updated;
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

  Future<bool> deleteSubject(String id) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteSubject(id);
      _subjects.removeWhere((s) => s.id == id);
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

