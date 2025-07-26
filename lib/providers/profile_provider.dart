import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  String _userName = 'Player';
  String get userName => _userName;

  String _avatarId = '1'; // Default to avatar_1.png
  String get avatarId => _avatarId;
  String get avatarAssetPath => 'assets/avatars/avatar_$_avatarId.png';

  ProfileProvider() {
    loadProfile();
  }

  void loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName') ?? 'Player';
    _avatarId = prefs.getString('avatarId') ?? '1';
    notifyListeners();
  }

  void setProfile(String newName, String newAvatarId) async {
    _userName = newName;
    _avatarId = newAvatarId;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _userName);
    await prefs.setString('avatarId', _avatarId);
    notifyListeners();
  }
}