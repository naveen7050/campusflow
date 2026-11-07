import '../../../core/network/api_client.dart';
import '../domain/models/material_model.dart';

class MaterialRepository {
  final ApiClient _apiClient;

  MaterialRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<List<MaterialModel>> getMaterials({
    String? subjectId,
    String? filter,
  }) async {
    final queryParams = <String>[];
    if (subjectId != null) queryParams.add('subjectId=$subjectId');
    if (filter != null) queryParams.add('filter=$filter');

    final queryString =
        queryParams.isNotEmpty ? '?${queryParams.join('&')}' : '';
    final response =
        await _apiClient.get('/materials$queryString', requireAuth: true);
    final data = response['data'] as Map<String, dynamic>;
    final list = data['materials'] as List<dynamic>;

    return list
        .map((item) => MaterialModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<MaterialModel> getMaterialById(String id) async {
    final response = await _apiClient.get('/materials/$id', requireAuth: true);
    final data = response['data'] as Map<String, dynamic>;
    return MaterialModel.fromJson(data['material'] as Map<String, dynamic>);
  }

  Future<MaterialModel> createMaterial({
    String? subjectId,
    required String title,
    String? fileUrl,
    String fileType = 'PDF',
    String fileSize = '1.2 MB',
    bool isShared = false,
  }) async {
    final response = await _apiClient.post(
      '/materials',
      requireAuth: true,
      body: {
        'subjectId': subjectId,
        'title': title.trim(),
        'fileUrl': fileUrl,
        'fileType': fileType,
        'fileSize': fileSize,
        'isShared': isShared,
      },
    );

    final data = response['data'] as Map<String, dynamic>;
    return MaterialModel.fromJson(data['material'] as Map<String, dynamic>);
  }

  Future<MaterialModel> updateMaterial({
    required String id,
    String? subjectId,
    String? title,
    String? fileUrl,
    String? fileType,
    String? fileSize,
    bool? isShared,
  }) async {
    final response = await _apiClient.put(
      '/materials/$id',
      requireAuth: true,
      body: {
        if (subjectId != null) 'subjectId': subjectId,
        if (title != null) 'title': title.trim(),
        if (fileUrl != null) 'fileUrl': fileUrl,
        if (fileType != null) 'fileType': fileType,
        if (fileSize != null) 'fileSize': fileSize,
        if (isShared != null) 'isShared': isShared,
      },
    );

    final data = response['data'] as Map<String, dynamic>;
    return MaterialModel.fromJson(data['material'] as Map<String, dynamic>);
  }

  Future<void> deleteMaterial(String id) async {
    await _apiClient.delete('/materials/$id', requireAuth: true);
  }
}

