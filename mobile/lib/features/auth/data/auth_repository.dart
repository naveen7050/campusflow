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
    if (token == null || token.isEmpty) return false;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final map = jsonDecode(payload) as Map<String, dynamic>;
      if (map.containsKey('exp')) {
        final exp = map['exp'] as int;
        final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
        if (DateTime.now().isAfter(expiryDate)) {
          await _storageService.clearAll();
          return false;
        }
      }
    } catch (_) {}
    return true;
  }

  Future<UserModel> updateProfile({
    String? fullName,
    String? department,
    int? semester,
  }) async {
    final response = await _apiClient.put(
      '/auth/profile',
      requireAuth: true,
      body: {
        if (fullName != null) 'fullName': fullName,
        if (department != null) 'department': department,
        if (semester != null) 'semester': semester,
      },
    );
    final data = response['data'] as Map<String, dynamic>;
    final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
    await _storageService.saveUserData(jsonEncode(user.toJson()));
    return user;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _apiClient.put(
      '/auth/change-password',
      requireAuth: true,
      body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }

  Future<void> logout() async {
    await _storageService.clearAll();
  }
}
