import '../../../core/network/api_client.dart';
import '../domain/models/subject_model.dart';

class SubjectRepository {
  final ApiClient _apiClient;

  SubjectRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<List<SubjectModel>> getSubjects() async {
    final response = await _apiClient.get('/subjects', requireAuth: true);
    final data = response['data'] as Map<String, dynamic>;
    final list = data['subjects'] as List<dynamic>;

    return list
        .map((item) => SubjectModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<SubjectModel> getSubjectById(String id) async {
    final response = await _apiClient.get('/subjects/$id', requireAuth: true);
    final data = response['data'] as Map<String, dynamic>;
    return SubjectModel.fromJson(data['subject'] as Map<String, dynamic>);
  }

  Future<SubjectModel> createSubject({
    required String name,
    String? code,
    String? description,
    int? semester,
    String? department,
    String color = '#0F5132',
    String icon = 'menu_book',
  }) async {
    final response = await _apiClient.post(
      '/subjects',
      requireAuth: true,
      body: {
        'name': name.trim(),
        'code': code?.trim(),
        'description': description?.trim(),
        'semester': semester,
        'department': department?.trim(),
        'color': color,
        'icon': icon,
      },
    );

    final data = response['data'] as Map<String, dynamic>;
    return SubjectModel.fromJson(data['subject'] as Map<String, dynamic>);
  }

  Future<SubjectModel> updateSubject({
    required String id,
    String? name,
    String? code,
    String? description,
    int? semester,
    String? department,
    String? color,
    String? icon,
  }) async {
    final response = await _apiClient.put(
      '/subjects/$id',
      requireAuth: true,
      body: {
        if (name != null) 'name': name.trim(),
        if (code != null) 'code': code.trim(),
        if (description != null) 'description': description.trim(),
        if (semester != null) 'semester': semester,
        if (department != null) 'department': department.trim(),
        if (color != null) 'color': color,
        if (icon != null) 'icon': icon,
      },
    );

    final data = response['data'] as Map<String, dynamic>;
    return SubjectModel.fromJson(data['subject'] as Map<String, dynamic>);
  }

  Future<void> deleteSubject(String id) async {
    await _apiClient.delete('/subjects/$id', requireAuth: true);
  }
}

