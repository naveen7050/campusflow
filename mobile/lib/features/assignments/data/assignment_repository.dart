import 'package:campusflow/core/network/api_client.dart';
import '../domain/models/assignment_model.dart';

class AssignmentRepository {
  final ApiClient _apiClient;

  AssignmentRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<List<AssignmentModel>> getAssignments({
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
      '/assignments$queryString',
      requireAuth: true,
    );

    if (response['success'] == true && response['data'] != null) {
      final list = response['data']['assignments'] as List<dynamic>? ?? [];
      return list
          .map((item) => AssignmentModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(response['message'] ?? 'Failed to retrieve assignments.');
    }
  }

  Future<AssignmentModel> createAssignment({
    String? subjectId,
    required String title,
    String? description,
    DateTime? dueDate,
    bool isSubmitted = false,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'isSubmitted': isSubmitted,
    };
    if (subjectId != null) body['subjectId'] = subjectId;
    if (description != null) body['description'] = description;
    if (dueDate != null) body['dueDate'] = dueDate.toIso8601String();

    final response = await _apiClient.post(
      '/assignments',
      body,
      requireAuth: true,
    );

    if (response['success'] == true && response['data'] != null) {
      return AssignmentModel.fromJson(
        response['data']['assignment'] as Map<String, dynamic>,
      );
    } else {
      throw Exception(response['message'] ?? 'Failed to create assignment.');
    }
  }

  Future<AssignmentModel> updateAssignment({
    required String id,
    String? subjectId,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isSubmitted,
  }) async {
    final body = <String, dynamic>{};
    if (subjectId != null) body['subjectId'] = subjectId;
    if (title != null) body['title'] = title;
    if (description != null) body['description'] = description;
    if (dueDate != null) body['dueDate'] = dueDate.toIso8601String();
    if (isSubmitted != null) body['isSubmitted'] = isSubmitted;

    final response = await _apiClient.put(
      '/assignments/$id',
      body,
      requireAuth: true,
    );

    if (response['success'] == true && response['data'] != null) {
      return AssignmentModel.fromJson(
        response['data']['assignment'] as Map<String, dynamic>,
      );
    } else {
      throw Exception(response['message'] ?? 'Failed to update assignment.');
    }
  }

  Future<AssignmentModel> toggleAssignment(String id) async {
    final response = await _apiClient.patch(
      '/assignments/$id/toggle',
      {},
      requireAuth: true,
    );

    if (response['success'] == true && response['data'] != null) {
      return AssignmentModel.fromJson(
        response['data']['assignment'] as Map<String, dynamic>,
      );
    } else {
      throw Exception(response['message'] ?? 'Failed to toggle assignment.');
    }
  }

  Future<void> deleteAssignment(String id) async {
    final response = await _apiClient.delete(
      '/assignments/$id',
      requireAuth: true,
    );

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to delete assignment.');
    }
  }
}
