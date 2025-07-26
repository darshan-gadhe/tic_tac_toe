import 'package:advanced_tic_tac_toe/providers/theme_provider.dart';
import 'package:advanced_tic_tac_toe/services/sound_service.dart' hide ThemeProvider;
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
    // Get the initial sound state from our service
    _isSoundEnabled = SoundService.isSoundEnabled();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the theme provider to get theme data
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView(
          children: [
            // --- Sound Setting ---
            SwitchListTile(
              title: const Text('Sound Effects'),
              value: _isSoundEnabled,
              onChanged: (bool value) {
                // Update the UI immediately
                setState(() {
                  _isSoundEnabled = value;
                });
                // Update the service and save the preference
                SoundService.toggleSound(value);
              },
              secondary: const Icon(Icons.volume_up_outlined),
            ),
            const Divider(),
            // --- Theme Setting ---
            ListTile(
              leading: const Icon(Icons.color_lens_outlined),
              title: const Text('App Theme'),
              trailing: DropdownButton<String>(
                value: themeProvider.currentTheme.name,
                // Create dropdown items from our list of available themes
                items: themeProvider.availableThemes.values.map((theme) {
                  return DropdownMenuItem<String>(
                    value: theme.name,
                    child: Text(theme.name),
                  );
                }).toList(),
                onChanged: (String? newThemeName) {
                  if (newThemeName != null) {
                    // Find the theme's key (e.g., 'dark', 'light') from its name
                    final themeKey = themeProvider.availableThemes.entries
                        .firstWhere((entry) => entry.value.name == newThemeName)
                        .key;
                    // Tell the provider to change the theme
                    themeProvider.setTheme(themeKey);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}