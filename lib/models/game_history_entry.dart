// import 'dart:convert'; // <-- THE FIX: REMOVE THIS LINE
import 'package:advanced_tic_tac_toe/utils/enums.dart';

class GameHistoryEntry {
  // ... rest of the file is correct
  final String winner;
  final DateTime timestamp;
  final GameMode gameMode;
  final AiDifficulty? aiDifficulty;

  GameHistoryEntry({
    required this.winner,
    required this.timestamp,
    required this.gameMode,
    this.aiDifficulty,
  });

  Map<String, dynamic> toJson() => {
    'winner': winner,
    'timestamp': timestamp.toIso8601String(),
    'gameMode': gameMode.toString(),
    'aiDifficulty': aiDifficulty?.toString(),
  };

  factory GameHistoryEntry.fromJson(Map<String, dynamic> json) {
    T? _enumFromString<T>(List<T> values, String? value) {
      if (value == null) return null;
      return values.firstWhere((v) => v.toString() == value);
    }

    return GameHistoryEntry(
      winner: json['winner'],
      timestamp: DateTime.parse(json['timestamp']),
      gameMode: _enumFromString(GameMode.values, json['gameMode'])!,
      aiDifficulty: _enumFromString(AiDifficulty.values, json['aiDifficulty']),
    );
  }
}