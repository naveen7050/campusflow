import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppConstants {
  AppConstants._();

  static const String appName = 'CampusFlow';

  static String get apiBaseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000/api';
    }
    return 'http://localhost:5000/api';
  }

  static const String tokenKey = 'campusflow_jwt_token';
  static const String userKey = 'campusflow_user_data';
}
