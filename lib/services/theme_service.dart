import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  static const String boxName = 'settingsBox';
  static const String keyThemeMode = 'isDarkMode';

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  late Box box;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() async {
    box = await Hive.openBox(boxName);
    _isDarkMode = box.get(keyThemeMode, defaultValue: false);
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    box.put(keyThemeMode, _isDarkMode);
    notifyListeners();
  }
}
