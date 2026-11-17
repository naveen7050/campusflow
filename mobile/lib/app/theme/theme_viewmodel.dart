import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeViewModel extends ChangeNotifier {
  static const _storageKey = 'campusflow_theme_mode';
  final _storage = const FlutterSecureStorage();

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeViewModel() {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    try {
      final saved = await _storage.read(key: _storageKey);
      if (saved == 'light') {
        _themeMode = ThemeMode.light;
      } else if (saved == 'dark') {
        _themeMode = ThemeMode.dark;
      } else if (saved == 'system') {
        _themeMode = ThemeMode.system;
      }
      notifyListeners();
    } catch (_) {}
  }

  String get themeModeName {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      try {
        await _storage.write(
          key: _storageKey,
          value: mode == ThemeMode.light
              ? 'light'
              : mode == ThemeMode.dark
                  ? 'dark'
                  : 'system',
        );
      } catch (_) {}
    }
  }

  void setThemeByName(String name) {
    if (name == 'Light') {
      setThemeMode(ThemeMode.light);
    } else if (name == 'Dark') {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.system);
    }
  }
}
