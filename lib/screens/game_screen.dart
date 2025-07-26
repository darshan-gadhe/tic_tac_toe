import 'package:advanced_tic_tac_toe/models/game_history_entry.dart';
import 'package:advanced_tic_tac_toe/services/history_service.dart';
import 'package:advanced_tic_tac_toe/services/sound_service.dart';
import 'package:advanced_tic_tac_toe/utils/ai_logic.dart';
import 'package:advanced_tic_tac_toe/utils/enums.dart';
import 'package:advanced_tic_tac_toe/utils/game_logic.dart';
import 'package:advanced_tic_tac_toe/widgets/score_board.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final GameMode gameMode;
  final AiDifficulty? aiDifficulty; // Nullable for Player vs Player mode

  const GameScreen({
    super.key,
    required this.gameMode,
    this.aiDifficulty,
  });

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // --- State Variables ---
  late List<String> _board;
  late bool _isPlayerXTurn;
  String? _winner;
  int _scoreX = 0;
  int _scoreO = 0;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  // --- Game Lifecycle Methods ---

  /// Sets all state variables to their default values for a new game.
  void _initializeGame() {
    _board = List.filled(9, '');
    _isPlayerXTurn = true;
    _winner = null;
  }

  /// Resets the game board for a new round within the same match.
  void _resetGame() {
    setState(() {
      _initializeGame();
    });
  }

  /// Handles the logic when a player taps on a tile.
  void _onTileTapped(int index) {
    // Ignore taps if the tile is already filled or if the game is over.
    if (_board[index].isNotEmpty || _winner != null) return;

    SoundService.playClickSound();

    setState(() {
      _board[index] = _isPlayerXTurn ? 'X' : 'O';
      _isPlayerXTurn = !_isPlayerXTurn;
      _checkWinner();
    });

    // If the game is not over and it's the AI's turn, make the AI move.
    if (_winner == null && widget.gameMode == GameMode.vsAI && !_isPlayerXTurn) {
      _makeAIMove();
    }
  }

  /// Checks the board for a winner or a draw.
  void _checkWinner() {
    String? winner = GameLogic.checkWinner(_board);
    if (winner != null) {
      setState(() {
        _winner = winner;
      });
      // If there's a result, save it and show the result dialog.
      _saveGameAndShowDialog();
    }
  }

  /// Handles the AI's turn.
  void _makeAIMove() {
    // Add a small delay for a more natural feel.
    Future.delayed(const Duration(milliseconds: 500), () {
      // Double-check that the game isn't over before the AI moves.
      if (_winner != null) return;

      int bestMove = AILogic.getMove(List.from(_board), widget.aiDifficulty!);
      if (bestMove != -1) {
        setState(() {
          _board[bestMove] = 'O';
          _isPlayerXTurn = true; // Switch turn back to the player.
          _checkWinner();
        });
      }
    });
  }

  /// A combined method to handle all post-game actions.
  void _saveGameAndShowDialog() {
    // 1. Save the game result to history.
    final entry = GameHistoryEntry(
      winner: _winner == 'draw' ? 'Draw' : _winner!,
      timestamp: DateTime.now(),
      gameMode: widget.gameMode,
      aiDifficulty: widget.aiDifficulty,
    );
    HistoryService.addEntry(entry);

    // 2. Update the score.
    if (_winner == 'X') _scoreX++;
    if (_winner == 'O') _scoreO++;

    // 3. Play the appropriate sound effect.
    if (_winner == 'draw') {
      SoundService.playDrawSound();
    } else {
      SoundService.playWinSound();
    }

    // 4. Show the result dialog.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            _winner == 'draw' ? "It's a Draw!" : "$_winner Wins!",
            style: TextStyle(
              color: _winner == 'X' ? Theme.of(context).colorScheme.primary : (_winner == 'O' ? Theme.of(context).colorScheme.secondary : null),
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: const Text('Play Again', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  // --- UI Builder Methods ---

  /// Builds the main UI of the screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScoreBoard(scoreX: _scoreX, scoreO: _scoreO),
            const SizedBox(height: 40),
            _buildGameBoard(),
            const SizedBox(height: 40),
            _buildTurnIndicator(),
          ],
        ),
      ),
    );
  }

  /// Builds the 3x3 game board grid.
  Widget _buildGameBoard() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: GridView.builder(
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _onTileTapped(index),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  _board[index],
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: _board[index] == 'X'
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds the text indicator below the board (e.g., "Turn: X" or "Winner!").
  Widget _buildTurnIndicator() {
    if (_winner != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _winner == 'draw' ? 'Game Over' : 'Winner!',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          _winner == 'draw'
              ? const Icon(Icons.handshake, size: 30)
              : Text(_winner!,
              style: TextStyle(
                  fontSize: 30,
                  color: _winner == 'X' ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold))
        ],
      );
    }
    return Text(
      'Turn: ${_isPlayerXTurn ? "X" : "O"}',
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  /// Helper to create a dynamic title for the AppBar.
  String _getAppBarTitle() {
    if (widget.gameMode == GameMode.vsPlayer) {
      return 'Player vs Player';
    }
    String diffText = widget.aiDifficulty.toString().split('.').last;
    diffText = diffText[0].toUpperCase() + diffText.substring(1);
    return 'You vs AI ($diffText)';
  }
}