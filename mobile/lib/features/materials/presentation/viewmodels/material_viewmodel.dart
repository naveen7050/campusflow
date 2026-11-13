import 'package:flutter/material.dart';
import '../../data/material_repository.dart';
import '../../domain/models/material_model.dart';

class MaterialViewModel extends ChangeNotifier {
  final MaterialRepository _repository;

  MaterialViewModel({MaterialRepository? repository})
      : _repository = repository ?? MaterialRepository();

  List<MaterialModel> _materials = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  String _selectedFilter = 'all'; // 'all', 'my', 'shared'
  String _searchQuery = '';
  String? _selectedSubjectId;

  List<MaterialModel> get materials => _materials;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  String get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;
  String? get selectedSubjectId => _selectedSubjectId;

  List<MaterialModel> get filteredMaterials {
    return _materials.where((mat) {
      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          mat.title.toLowerCase().contains(query) ||
          (mat.subjectName?.toLowerCase().contains(query) ?? false) ||
          mat.fileType.toLowerCase().contains(query);

      final matchesSubject = _selectedSubjectId == null ||
          mat.subjectId == _selectedSubjectId;

      return matchesSearch && matchesSubject;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    fetchMaterials(subjectId: _selectedSubjectId, filter: filter);
  }

  void setSubjectFilter(String? subjectId) {
    _selectedSubjectId = subjectId;
    fetchMaterials(subjectId: subjectId, filter: _selectedFilter);
  }

  Future<void> fetchMaterials({String? subjectId, String? filter}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _materials = await _repository.getMaterials(
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

  Future<bool> createMaterial({
    String? subjectId,
    required String title,
    String? fileUrl,
    String fileType = 'PDF',
    String fileSize = '1.2 MB',
    bool isShared = false,
  }) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newMaterial = await _repository.createMaterial(
        subjectId: subjectId,
        title: title,
        fileUrl: fileUrl,
        fileType: fileType,
        fileSize: fileSize,
        isShared: isShared,
      );
      _materials.insert(0, newMaterial);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> updateMaterial({
    required String id,
    String? subjectId,
    String? title,
    String? fileUrl,
    String? fileType,
    String? fileSize,
    bool? isShared,
  }) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _repository.updateMaterial(
        id: id,
        subjectId: subjectId,
        title: title,
        fileUrl: fileUrl,
        fileType: fileType,
        fileSize: fileSize,
        isShared: isShared,
      );

      final index = _materials.indexWhere((m) => m.id == id);
      if (index != -1) {
        _materials[index] = updated;
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

  Future<bool> toggleShare(MaterialModel material) async {
    return updateMaterial(
      id: material.id,
      isShared: !material.isShared,
    );
  }

  Future<bool> deleteMaterial(String id) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteMaterial(id);
      _materials.removeWhere((m) => m.id == id);
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

