import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../app/constants/app_constants.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: AppConstants.tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: AppConstants.tokenKey);
  }

  Future<void> saveUserData(String userDataJson) async {
    await _storage.write(key: AppConstants.userKey, value: userDataJson);
  }

  Future<String?> getUserData() async {
    return await _storage.read(key: AppConstants.userKey);
  }

  Future<void> clearAll() async {
    await _storage.delete(key: AppConstants.tokenKey);
    await _storage.delete(key: AppConstants.userKey);
  }
}
