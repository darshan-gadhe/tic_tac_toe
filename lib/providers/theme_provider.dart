import 'package:advanced_tic_tac_toe/models/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  // Define all available themes
  static final Map<String, AppTheme> _availableThemes = {
    'dark': AppTheme(
      name: 'Dark',
      logoAssetPath: 'assets/logo_dark.png',
      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF1A2A33),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF31C3BD), // X color
          secondary: Color(0xFFF2B137), // O color
          background: Color(0xFF1A2A33),
          surface: Color(0xFF1F3641), // Tile color
        ),
      ),
    ),
    'light': AppTheme(
      name: 'Light',
      logoAssetPath: 'assets/logo_light.png',
      themeData: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFFE0FBFC),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF3D5A80), // X color
          secondary: Color(0xFFEE6C4D), // O color
          background: Color(0xFFE0FBFC),
          surface: Colors.white, // Tile color
        ),
      ),
    ),
    'ocean': AppTheme(
      name: 'Ocean',
      logoAssetPath: 'assets/logo_ocean.png',
      themeData: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF006064),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF80DEEA), // X color
          secondary: Color(0xFFFFAB91), // O color
          background: Color(0xFF006064),
          surface: Color(0xFF004D40), // Tile color
        ),
      ),
    ),
  };

  late AppTheme _currentTheme;
  AppTheme get currentTheme => _currentTheme;
  Map<String, AppTheme> get availableThemes => _availableThemes;

  ThemeProvider() {
    // Set a default theme before loading
    _currentTheme = _availableThemes['dark']!;
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    String themeKey = prefs.getString('theme_key') ?? 'dark';
    _currentTheme = _availableThemes[themeKey] ?? _availableThemes['dark']!;
    notifyListeners();
  }

  void setTheme(String themeKey) async {
    if (_availableThemes.containsKey(themeKey)) {
      _currentTheme = _availableThemes[themeKey]!;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme_key', themeKey);
      notifyListeners();
    }
  }
}