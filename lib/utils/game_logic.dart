class GameLogic {
  static String? checkWinner(List<String> board) {
    // Winning combinations
    const List<List<int>> winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6]             // Diagonals
    ];

    for (var pattern in winPatterns) {
      String p1 = board[pattern[0]];
      String p2 = board[pattern[1]];
      String p3 = board[pattern[2]];

      if (p1.isNotEmpty && p1 == p2 && p2 == p3) {
        return p1; // Returns 'X' or 'O'
      }
    }

    // Check for a draw (no empty cells left)
    if (!board.contains('')) {
      return 'draw';
    }

    return null; // Game is still ongoing
  }
}