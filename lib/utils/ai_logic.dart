import 'dart:math';
import 'package:advanced_tic_tac_toe/utils/enums.dart';
import 'package:advanced_tic_tac_toe/utils/game_logic.dart';

class AILogic {
  /// Main method to get the AI's move based on difficulty and grid size.
  static int getMove(List<String> board, AiDifficulty difficulty, int size) {
    switch (difficulty) {
      case AiDifficulty.simple:
        return _getRandomMove(board);
      case AiDifficulty.medium:
      // 70% chance for a perfect move, 30% for a random one.
        return Random().nextDouble() < 0.7
            ? _findBestMoveMinimax(board, size)
            : _getRandomMove(board);
      case AiDifficulty.hard:
        return _findBestMoveMinimax(board, size);
    }
  }

  /// Strategy 1: Simple Random Move. Works for any grid size.
  static int _getRandomMove(List<String> board) {
    List<int> emptyIndices = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        emptyIndices.add(i);
      }
    }
    return emptyIndices.isNotEmpty ? emptyIndices[Random().nextInt(emptyIndices.length)] : -1;
  }

  /// Strategy 2: Unbeatable Minimax (for Hard and Medium).
  static int _findBestMoveMinimax(List<String> board, int size) {
    int bestMove = -1;
    int bestScore = -10000;

    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        board[i] = 'O'; // AI's move
        int score = _minimax(board, 0, false, size);
        board[i] = ''; // Undo the move

        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }
    return bestMove;
  }

  /// The recursive Minimax algorithm implementation.
  static int _minimax(List<String> board, int depth, bool isMaximizing, int size) {
    // CRITICAL: Add a depth limit for performance on larger boards.
    // Without this, 4x4 would be slow and 5x5 would freeze the app.
    int maxDepth = (size == 3) ? 9 : (size == 4 ? 4 : 3);
    if (depth >= maxDepth) {
      return 0; // Return a neutral score if max depth is reached.
    }

    String? winner = GameLogic.checkWinner(board, size);
    if (winner != null) {
      if (winner == 'O') return 100 - depth; // AI wins, prioritize faster wins.
      if (winner == 'X') return depth - 100; // Player wins, prioritize blocking.
      if (winner == 'draw') return 0;
    }

    if (isMaximizing) { // AI's turn (O - Maximizer)
      int bestScore = -10000;
      for (int i = 0; i < board.length; i++) {
        if (board[i] == '') {
          board[i] = 'O';
          int score = _minimax(board, depth + 1, false, size);
          board[i] = '';
          bestScore = max(score, bestScore);
        }
      }
      return bestScore;
    } else { // Player's turn (X - Minimizer)
      int bestScore = 10000;
      for (int i = 0; i < board.length; i++) {
        if (board[i] == '') {
          board[i] = 'X';
          int score = _minimax(board, depth + 1, true, size);
          board[i] = '';
          bestScore = min(score, bestScore);
        }
      }
      return bestScore;
    }
  }
}