import 'dart:math';
import 'package:advanced_tic_tac_toe/utils/game_logic.dart';
import 'package:advanced_tic_tac_toe/utils/enums.dart'; // <-- ADD THIS IMPORT

// REMOVE 'enum AiDifficulty' from here

class AILogic {
  // Main method to get the AI's move based on difficulty
  static int getMove(List<String> board, AiDifficulty difficulty) {
    switch (difficulty) {
      case AiDifficulty.simple:
        return _getRandomMove(board);
      case AiDifficulty.medium:
        if (Random().nextDouble() < 0.7) {
          return _findBestMoveMinimax(board);
        } else {
          return _getRandomMove(board);
        }
      case AiDifficulty.hard:
        return _findBestMoveMinimax(board);
    }
  }

  // ... (rest of the file is unchanged)

  static int _getRandomMove(List<String> board) {
    List<int> emptyIndices = [];
    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        emptyIndices.add(i);
      }
    }
    if (emptyIndices.isEmpty) return -1;
    return emptyIndices[Random().nextInt(emptyIndices.length)];
  }

  static int _findBestMoveMinimax(List<String> board) {
    int bestMove = -1;
    int bestScore = -1000;
    for (int i = 0; i < board.length; i++) {
      if (board[i] == '') {
        board[i] = 'O';
        int score = _minimax(board, 0, false);
        board[i] = '';
        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }
    return bestMove;
  }

  static int _minimax(List<String> board, int depth, bool isMaximizing) {
    String? winner = GameLogic.checkWinner(board);
    if (winner != null) {
      if (winner == 'O') return 10 - depth;
      if (winner == 'X') return depth - 10;
      if (winner == 'draw') return 0;
    }
    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < board.length; i++) {
        if (board[i] == '') {
          board[i] = 'O';
          int score = _minimax(board, depth + 1, false);
          board[i] = '';
          bestScore = max(score, bestScore);
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < board.length; i++) {
        if (board[i] == '') {
          board[i] = 'X';
          int score = _minimax(board, depth + 1, true);
          board[i] = '';
          bestScore = min(score, bestScore);
        }
      }
      return bestScore;
    }
  }
}