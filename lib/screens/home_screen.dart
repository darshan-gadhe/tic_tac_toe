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
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
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
              // The logo is now dynamic, based on the selected theme
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
                    () => _navigateToGameScreen(context, GameMode.vsPlayer),
                Theme.of(context).colorScheme.primary, // X color
              ),
              const SizedBox(height: 20),
              _buildGameModeButton(
                context,
                'Player vs AI',
                    () => _showDifficultyDialog(context),
                Theme.of(context).colorScheme.secondary, // O color
              ),
              const SizedBox(height: 40),
              TextButton.icon(
                icon: const Icon(Icons.history),
                label: const Text('Game History'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToGameScreen(BuildContext context, GameMode mode, {AiDifficulty? difficulty}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(gameMode: mode, aiDifficulty: difficulty),
      ),
    );
  }

  void _showDifficultyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select AI Difficulty'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDifficultyButton(context, 'Simple', AiDifficulty.simple),
            _buildDifficultyButton(context, 'Medium', AiDifficulty.medium),
            _buildDifficultyButton(context, 'Hard', AiDifficulty.hard),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(BuildContext context, String text, AiDifficulty difficulty) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          _navigateToGameScreen(context, GameMode.vsAI, difficulty: difficulty);
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(200, 50),
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        child: Text(text),
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