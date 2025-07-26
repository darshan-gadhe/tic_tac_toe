import 'package:advanced_tic_tac_toe/providers/profile_provider.dart';
import 'package:advanced_tic_tac_toe/screens/game_screen.dart';
import 'package:advanced_tic_tac_toe/screens/history_screen.dart';
import 'package:advanced_tic_tac_toe/screens/profile_screen.dart';
import 'package:advanced_tic_tac_toe/screens/settings_screen.dart'; // <-- THIS IS THE FIX
import 'package:advanced_tic_tac_toe/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildProfileHeader(context),
              const Spacer(),
              _buildTitle(context),
              const SizedBox(height: 40),
              _buildGameButton(
                context,
                text: 'Player vs Player',
                onPressed: () => _showGridSizeDialog(context, GameMode.vsPlayer),
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              _buildGameButton(
                context,
                text: 'Player vs AI',
                onPressed: () => _showDifficultyDialog(context),
                color: Theme.of(context).colorScheme.secondary,
              ),
              const Spacer(),
              _buildFooterButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profile, child) {
        return InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(backgroundImage: AssetImage(profile.avatarAssetPath), radius: 24),
                const SizedBox(width: 12),
                Text('Hi, ${profile.userName}', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'TIC TAC TOE',
      style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildGameButton(BuildContext context, {required String text, required VoidCallback onPressed, required Color color}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      child: Text(text),
    );
  }

  Widget _buildFooterButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.history, size: 30),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
          tooltip: 'Game History',
        ),
        IconButton(
          icon: const Icon(Icons.settings, size: 30),
          // This line was causing the error before the import was added.
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
          tooltip: 'Settings',
        ),
      ],
    );
  }

  // --- DIALOGS & NAVIGATION ---

  void _showDifficultyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Select AI Difficulty'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogButton(dialogContext, 'Simple', () => _showGridSizeDialog(context, GameMode.vsAI, difficulty: AiDifficulty.simple)),
            _buildDialogButton(dialogContext, 'Medium', () => _showGridSizeDialog(context, GameMode.vsAI, difficulty: AiDifficulty.medium)),
            _buildDialogButton(dialogContext, 'Hard', () => _showGridSizeDialog(context, GameMode.vsAI, difficulty: AiDifficulty.hard)),
          ],
        ),
      ),
    );
  }

  void _showGridSizeDialog(BuildContext context, GameMode mode, {AiDifficulty? difficulty}) {
    if(Navigator.canPop(context)) Navigator.of(context).pop(); // Close previous dialog if any

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Select Grid Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogButton(dialogContext, '3 x 3', () => _navigateToGame(context, mode: mode, difficulty: difficulty, gridSize: 3)),
            _buildDialogButton(dialogContext, '4 x 4', () => _navigateToGame(context, mode: mode, difficulty: difficulty, gridSize: 4)),
            _buildDialogButton(dialogContext, '5 x 5', () => _navigateToGame(context, mode: mode, difficulty: difficulty, gridSize: 5)),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogButton(BuildContext context, String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
        child: Text(text),
      ),
    );
  }

  void _navigateToGame(BuildContext context, {required GameMode mode, required int gridSize, AiDifficulty? difficulty}) {
    Navigator.of(context).pop(); // Close the grid size dialog
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(gameMode: mode, gridSize: gridSize, aiDifficulty: difficulty),
      ),
    );
  }
}