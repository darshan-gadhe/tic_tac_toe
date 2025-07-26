import 'package:advanced_tic_tac_toe/providers/theme_provider.dart';
import 'package:advanced_tic_tac_toe/services/history_service.dart';
import 'package:advanced_tic_tac_toe/services/sound_service.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Local state for the sound switch to provide an instant UI update.
  late bool _isSoundEnabled;

  @override
  void initState() {
    super.initState();
    _isSoundEnabled = SoundService.isSoundEnabled();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the ThemeProvider to get the current theme.
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'General'),

          // --- Sound On/Off Option ---
          SwitchListTile(
            title: const Text('Sound Effects'),
            value: _isSoundEnabled,
            onChanged: (bool value) {
              setState(() => _isSoundEnabled = value); // Update UI instantly
              SoundService.toggleSound(value); // Save preference
            },
            secondary: const Icon(Icons.volume_up_outlined),
          ),

          // --- Change Theme Option ---
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
          _buildSectionHeader(context, 'Feedback & Sharing'),

          // --- Share App Option ---
          ListTile(
            leading: const Icon(Icons.share_outlined),
            title: const Text('Share this App'),
            onTap: () {
              // TODO: Replace with your actual app link from the app store.
              Share.share('Check out this awesome Tic Tac Toe game! https://play.google.com/store/apps/details?id=com.itechcoderdev.tictactoe&hl=en');
            },
          ),

          // --- Review App Option ---
          ListTile(
            leading: const Icon(Icons.rate_review_outlined),
            title: const Text('Review this App'),
            onTap: () async {
              final InAppReview inAppReview = InAppReview.instance;
              if (await inAppReview.isAvailable()) {
                inAppReview.requestReview();
              } else {
                // Optionally handle the case where the review dialog isn't available
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("In-app review is not available right now.")),
                );
              }
            },
          ),

          const Divider(),
          _buildSectionHeader(context, 'Data Management'),

          // --- Clear History Option ---
          ListTile(
            leading: Icon(Icons.delete_sweep_outlined, color: Colors.red.shade400),
            title: Text('Clear Game History', style: TextStyle(color: Colors.red.shade400)),
            onTap: () => _showClearHistoryConfirmation(context),
          ),
        ],
      ),
    );
  }

  /// Helper widget to create styled section headers.
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  /// Shows a confirmation dialog before clearing game history.
  void _showClearHistoryConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('This will permanently delete all game records.'),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(ctx).pop()),
          TextButton(
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
            onPressed: () {
              HistoryService.clearHistory();
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Game history cleared!')),
              );
            },
          ),
        ],
      ),
    );
  }
}