import 'package:advanced_tic_tac_toe/providers/settings_provider.dart'; // We will create this
import 'package:advanced_tic_tac_toe/providers/theme_provider.dart';
import 'package:advanced_tic_tac_toe/services/sound_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isSoundEnabled;
  @override
  void initState() {
    super.initState();
    _isSoundEnabled = SoundService.isSoundEnabled();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          SwitchListTile(
            title: const Text('Sound Effects'),
            value: _isSoundEnabled,
            onChanged: (bool value) {
              setState(() => _isSoundEnabled = value);
              SoundService.toggleSound(value);
            },
            secondary: const Icon(Icons.volume_up_outlined),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.color_lens_outlined),
            title: const Text('App Theme'),
            trailing: DropdownButton<String>(
              value: themeProvider.currentTheme.name,
              items: themeProvider.availableThemes.values.map((theme) {
                return DropdownMenuItem<String>(value: theme.name, child: Text(theme.name));
              }).toList(),
              onChanged: (String? newThemeName) {
                if (newThemeName != null) {
                  final themeKey = themeProvider.availableThemes.entries.firstWhere((e) => e.value.name == newThemeName).key;
                  themeProvider.setTheme(themeKey);
                }
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.grid_on),
            title: const Text('Grid Size'),
            trailing: DropdownButton<int>(
              value: settingsProvider.gridSize,
              items: <int>[3, 4, 5].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(value: value, child: Text('$value x $value'));
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  settingsProvider.setGridSize(newValue);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}