import 'dart:convert';
import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../domain/models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final SecureStorageService _storageService;

  AuthRepository({
    ApiClient? apiClient,
    SecureStorageService? storageService,
  })  : _apiClient = apiClient ?? ApiClient(),
        _storageService = storageService ?? SecureStorageService();

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      '/auth/login',
      body: {
        'email': email.trim(),
        'password': password,
      },
    );

    final data = response['data'] as Map<String, dynamic>;
    final token = data['token'] as String;
    final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);

    await _storageService.saveToken(token);
    await _storageService.saveUserData(jsonEncode(user.toJson()));

    return user;
  }

  Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
    String? studentId,
    String? department,
    int? semester,
    String role = 'student',
  }) async {
    final response = await _apiClient.post(
      '/auth/register',
      body: {
        'fullName': fullName.trim(),
        'email': email.trim(),
        'password': password,
        'studentId': studentId?.trim(),
        'department': department?.trim(),
        'semester': semester,
        'role': role,
      },
    );

    final data = response['data'] as Map<String, dynamic>;
    final token = data['token'] as String;
    final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);

    await _storageService.saveToken(token);
    await _storageService.saveUserData(jsonEncode(user.toJson()));

    return user;
  }

  Future<UserModel?> getCachedUser() async {
    final userJson = await _storageService.getUserData();
    if (userJson == null) return null;
    try {
      final map = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<UserModel?> getProfile() async {
    try {
      final response = await _apiClient.get('/auth/me', requireAuth: true);
      final data = response['data'] as Map<String, dynamic>;
      final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      await _storageService.saveUserData(jsonEncode(user.toJson()));
      return user;
    } catch (_) {
      return await getCachedUser();
    }
  }

  Future<bool> hasValidToken() async {
    final token = await _storageService.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await _storageService.clearAll();
  }
}
