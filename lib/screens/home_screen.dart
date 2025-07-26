import 'package:advanced_tic_tac_toe/providers/theme_provider.dart';
import 'package:advanced_tic_tac_toe/screens/game_screen.dart';
import 'package:advanced_tic_tac_toe/screens/history_screen.dart';
import 'package:advanced_tic_tac_toe/screens/settings_screen.dart';
import 'package:advanced_tic_tac_toe/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
            tooltip: 'Settings',
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(themeProvider.currentTheme.logoAssetPath, height: 100),
              const SizedBox(height: 20),
              Text(
                'TIC TAC TOE',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 60),
              _buildGameModeButton(
                context,
                'Player vs Player',
                    () => _showGridSizeDialog(context, GameMode.vsPlayer),
                Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              _buildGameModeButton(
                context,
                'Player vs AI',
                    () => _showDifficultyDialog(context),
                Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 40),
              TextButton.icon(
                icon: const Icon(Icons.history),
                label: const Text('Game History'),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ... inside HomeScreen class

  void _navigateToGameScreen(BuildContext context, GameMode mode, int size, {AiDifficulty? difficulty}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // THE FIX: Ensure there is NO gridSize parameter here.
        builder: (context) => GameScreen(gameMode: mode, aiDifficulty: difficulty),
      ),
    );
  }

// ... rest of the file

  void _showGridSizeDialog(BuildContext context, GameMode mode, {AiDifficulty? difficulty}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select Grid Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [3, 4, 5].map((size) {
            return ListTile(
              title: Text('$size x $size'),
              onTap: () {
                Navigator.of(ctx).pop(); // Close grid size dialog
                _navigateToGameScreen(context, mode, size, difficulty: difficulty);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDifficultyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select AI Difficulty'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AiDifficulty.values.map((diff) {
            return ListTile(
              title: Text(diff.name[0].toUpperCase() + diff.name.substring(1)),
              onTap: () {
                Navigator.of(ctx).pop(); // Close difficulty dialog
                _showGridSizeDialog(context, GameMode.vsAI, difficulty: diff);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildGameModeButton(BuildContext context, String text, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(250, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      child: Text(text),
    );
  }
}