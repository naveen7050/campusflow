class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Network connection failed.']);
}

class AuthException extends AppException {
  const AuthException(super.message, [super.statusCode]);
}

class ServerException extends AppException {
  const ServerException([String message = 'Server error occurred.'])
      : super(message, 500);
}
