import 'package:flutter/foundation.dart';
import '../../data/auth_repository.dart';
import '../../domain/models/user_model.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;

  AuthViewModel({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated && _user != null;

  Future<void> checkAuthStatus() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final hasToken = await _repository.hasValidToken();
      if (!hasToken) {
        _status = AuthStatus.unauthenticated;
        _user = null;
        notifyListeners();
        return;
      }

      final profile = await _repository.getProfile();
      if (profile != null) {
        _user = profile;
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
        _user = null;
      }
    } catch (_) {
      _status = AuthStatus.unauthenticated;
      _user = null;
    }

    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _repository.login(email: email, password: password);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    String? studentId,
    String? department,
    int? semester,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _repository.register(
        fullName: fullName,
        email: email,
        password: password,
        studentId: studentId,
        department: department,
        semester: semester,
      );
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }
}
