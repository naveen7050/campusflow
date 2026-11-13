import 'package:flutter/material.dart';

class ThemeViewModel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

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

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
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

