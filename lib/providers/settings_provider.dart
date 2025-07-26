import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  int _gridSize = 3;
  int get gridSize => _gridSize;

  SettingsProvider() {
    _loadGridSize();
  }

  /// Loads the grid size from device storage when the app starts.
  void _loadGridSize() async {
    final prefs = await SharedPreferences.getInstance();
    // Defaults to 3 if no setting has been saved yet.
    _gridSize = prefs.getInt('grid_size') ?? 3;
    notifyListeners();
  }

  /// Sets a new grid size and saves it to device storage.
  void setGridSize(int size) async {
    if (_gridSize == size) return; // No change needed

    _gridSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('grid_size', size);
    notifyListeners();
  }
}