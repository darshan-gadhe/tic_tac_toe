import 'dart:convert';
import 'package:advanced_tic_tac_toe/utils/enums.dart';

class GameHistoryEntry {
  final String winner; // 'X', 'O', or 'Draw'
  final DateTime timestamp;
  final GameMode gameMode;
  final AiDifficulty? aiDifficulty;

  GameHistoryEntry({
    required this.winner,
    required this.timestamp,
    required this.gameMode,
    this.aiDifficulty,
  });

  /// Converts the object to a Map, which can then be JSON encoded.
  /// This is for SAVING data.
  Map<String, dynamic> toJson() => {
    'winner': winner,
    // Convert DateTime to a standard string format.
    'timestamp': timestamp.toIso8601String(),
    // Convert enums to their string representation.
    'gameMode': gameMode.toString(),
    'aiDifficulty': aiDifficulty?.toString(),
  };

  /// Creates an object from a Map (decoded from JSON).
  /// This is for LOADING data.
  factory GameHistoryEntry.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse enums from string.
    T? _enumFromString<T>(List<T> values, String? value) {
      if (value == null) return null;
      return values.firstWhere((v) => v.toString() == value);
    }

    return GameHistoryEntry(
      winner: json['winner'],
      // Parse the standard string back into a DateTime object.
      timestamp: DateTime.parse(json['timestamp']),
      // Parse the string back into a GameMode enum.
      gameMode: _enumFromString(GameMode.values, json['gameMode'])!,
      // Safely parse the string back into an AiDifficulty enum (or null).
      aiDifficulty: _enumFromString(AiDifficulty.values, json['aiDifficulty']),
    );
  }
}