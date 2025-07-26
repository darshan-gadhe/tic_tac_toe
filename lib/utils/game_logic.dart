class GameLogic {
  static String? checkWinner(List<String> board, int size) {
    // final int winCondition = size; // <-- THE FIX: REMOVE THIS LINE

    List<List<int>> winPatterns = [];
    // ... rest of the file is correct
    for (int i = 0; i < size * size; i += size) {
      winPatterns.add(List.generate(size, (j) => i + j));
    }
    for (int i = 0; i < size; i++) {
      winPatterns.add(List.generate(size, (j) => i + j * size));
    }
    winPatterns.add(List.generate(size, (i) => i * (size + 1)));
    winPatterns.add(List.generate(size, (i) => (i + 1) * (size - 1)));
    for (var pattern in winPatterns) {
      String first = board[pattern[0]];
      if (first.isNotEmpty && pattern.every((index) => board[index] == first)) {
        return first;
      }
    }
    if (!board.contains('')) {
      return 'draw';
    }
    return null;
  }
}