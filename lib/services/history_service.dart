import 'dart:convert';
import 'package:advanced_tic_tac_toe/models/game_history_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  static const _historyKey = 'game_history';

  static Future<void> addEntry(GameHistoryEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();
    history.insert(0, entry); // Add new entry to the top of the list

    // Convert list of objects to list of JSON strings
    final List<String> historyJson = history.map((e) => jsonEncode(e.toJson())).toList();

    await prefs.setStringList(_historyKey, historyJson);
  }

  static Future<List<GameHistoryEntry>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? historyJson = prefs.getStringList(_historyKey);

    if (historyJson == null) {
      return [];
    }

    // Convert list of JSON strings back to list of objects
    return historyJson.map((e) => GameHistoryEntry.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}