import '../../../core/network/api_client.dart';
import '../domain/models/note_model.dart';

class NoteRepository {
  final ApiClient _apiClient;

  NoteRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<List<NoteModel>> getNotes({
    String? subjectId,
    String? filter,
  }) async {
    final queryParams = <String>[];
    if (subjectId != null) queryParams.add('subjectId=$subjectId');
    if (filter != null) queryParams.add('filter=$filter');

    final queryString =
        queryParams.isNotEmpty ? '?${queryParams.join('&')}' : '';
    final response =
        await _apiClient.get('/notes$queryString', requireAuth: true);
    final data = response['data'] as Map<String, dynamic>;
    final list = data['notes'] as List<dynamic>;

    return list
        .map((item) => NoteModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<NoteModel> getNoteById(String id) async {
    final response = await _apiClient.get('/notes/$id', requireAuth: true);
    final data = response['data'] as Map<String, dynamic>;
    return NoteModel.fromJson(data['note'] as Map<String, dynamic>);
  }

  Future<NoteModel> createNote({
    String? subjectId,
    required String title,
    String content = '',
    List<String> tags = const [],
    bool isShared = false,
  }) async {
    final response = await _apiClient.post(
      '/notes',
      requireAuth: true,
      body: {
        'subjectId': subjectId,
        'title': title.trim(),
        'content': content,
        'tags': tags,
        'isShared': isShared,
      },
    );

    final data = response['data'] as Map<String, dynamic>;
    return NoteModel.fromJson(data['note'] as Map<String, dynamic>);
  }

  Future<NoteModel> updateNote({
    required String id,
    String? subjectId,
    String? title,
    String? content,
    List<String>? tags,
    bool? isShared,
  }) async {
    final response = await _apiClient.put(
      '/notes/$id',
      requireAuth: true,
      body: {
        if (subjectId != null) 'subjectId': subjectId,
        if (title != null) 'title': title.trim(),
        if (content != null) 'content': content,
        if (tags != null) 'tags': tags,
        if (isShared != null) 'isShared': isShared,
      },
    );

    final data = response['data'] as Map<String, dynamic>;
    return NoteModel.fromJson(data['note'] as Map<String, dynamic>);
  }

  Future<void> deleteNote(String id) async {
    await _apiClient.delete('/notes/$id', requireAuth: true);
  }
}

