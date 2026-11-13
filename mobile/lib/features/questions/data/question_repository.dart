import 'package:campusflow/core/network/api_client.dart';
import '../domain/models/question_model.dart';

class QuestionRepository {
  final ApiClient _apiClient;

  QuestionRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<List<QuestionModel>> getQuestions({
    String? subjectId,
    String? filter,
  }) async {
    final queryParams = <String, String>{};
    if (subjectId != null && subjectId.isNotEmpty) {
      queryParams['subjectId'] = subjectId;
    }
    if (filter != null && filter.isNotEmpty) {
      queryParams['filter'] = filter;
    }

    final queryString = queryParams.isNotEmpty
        ? '?${queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&')}'
        : '';

    final response = await _apiClient.get(
      '/questions$queryString',
      requireAuth: true,
    );

    if (response['success'] == true && response['data'] != null) {
      final list = response['data']['questions'] as List<dynamic>? ?? [];
      return list
          .map((item) => QuestionModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(response['message'] ?? 'Failed to retrieve questions.');
    }
  }

  Future<QuestionModel> createQuestion({
    String? subjectId,
    required String question,
    String? answer,
    String? imageUrl,
    bool isStarred = false,
    bool isShared = false,
  }) async {
    final body = <String, dynamic>{
      'question': question,
      'isStarred': isStarred,
      'isShared': isShared,
    };
    if (subjectId != null) body['subjectId'] = subjectId;
    if (answer != null) body['answer'] = answer;
    if (imageUrl != null) body['imageUrl'] = imageUrl;

    final response = await _apiClient.post(
      '/questions',
      body: body,
      requireAuth: true,
    );

    if (response['success'] == true && response['data'] != null) {
      return QuestionModel.fromJson(
        response['data']['question'] as Map<String, dynamic>,
      );
    } else {
      throw Exception(response['message'] ?? 'Failed to create question.');
    }
  }

  Future<QuestionModel> updateQuestion({
    required String id,
    String? subjectId,
    String? question,
    String? answer,
    String? imageUrl,
    bool? isStarred,
    bool? isShared,
  }) async {
    final body = <String, dynamic>{};
    if (subjectId != null) body['subjectId'] = subjectId;
    if (question != null) body['question'] = question;
    if (answer != null) body['answer'] = answer;
    if (imageUrl != null) body['imageUrl'] = imageUrl;
    if (isStarred != null) body['isStarred'] = isStarred;
    if (isShared != null) body['isShared'] = isShared;

    final response = await _apiClient.put(
      '/questions/$id',
      body: body,
      requireAuth: true,
    );

    if (response['success'] == true && response['data'] != null) {
      return QuestionModel.fromJson(
        response['data']['question'] as Map<String, dynamic>,
      );
    } else {
      throw Exception(response['message'] ?? 'Failed to update question.');
    }
  }

  Future<QuestionModel> toggleStar(String id) async {
    final response = await _apiClient.patch(
      '/questions/$id/star',
      body: {},
      requireAuth: true,
    );

    if (response['success'] == true && response['data'] != null) {
      return QuestionModel.fromJson(
        response['data']['question'] as Map<String, dynamic>,
      );
    } else {
      throw Exception(response['message'] ?? 'Failed to update star status.');
    }
  }

  Future<void> deleteQuestion(String id) async {
    final response = await _apiClient.delete(
      '/questions/$id',
      requireAuth: true,
    );

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to delete question.');
    }
  }
}

