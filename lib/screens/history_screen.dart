import 'package:advanced_tic_tac_toe/models/game_history_entry.dart';
import 'package:advanced_tic_tac_toe/services/history_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // This Future will hold our list of history entries.
  late Future<List<GameHistoryEntry>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    // Assign the Future from our service to the state variable.
    _historyFuture = HistoryService.getHistory();
  }

  void _clearHistory() async {
    await HistoryService.clearHistory();
    // After clearing, we MUST call setState to rebuild the widget
    // with a new Future, so the UI updates to show an empty list.
    setState(() {
      _loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game History'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => _showClearConfirmationDialog(),
            tooltip: 'Clear History',
          ),
        ],
      ),
      body: FutureBuilder<List<GameHistoryEntry>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          // Case 1: The Future is still running.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Case 2: The Future completed, but with an error.
          if (snapshot.hasError) {
            return Center(child: Text("Error loading history: ${snapshot.error}"));
          }
          // Case 3: The Future completed, but the list is empty or null.
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No games played yet!',
                style: TextStyle(fontSize: 20),
              ),
            );
          }

          // Case 4: We have data!
          final history = snapshot.data!;
          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final entry = history[index];
              return ListTile(
                leading: _buildWinnerIcon(entry.winner),
                title: Text(_getWinnerMessage(entry)),
                subtitle: Text(
                  DateFormat.yMMMd().add_jm().format(entry.timestamp),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showClearConfirmationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to permanently delete all game history?'),
        actions: [
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(ctx).pop();
              _clearHistory();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWinnerIcon(String winner) {
    if (winner == 'Draw') {
      return const Icon(Icons.handshake, color: Colors.grey);
    }
    return Text(
      winner,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: winner == 'X'
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  String _getWinnerMessage(GameHistoryEntry entry) {
    if (entry.winner == 'Draw') {
      return "Game was a draw";
    }
    return "${entry.winner} won the game";
  }
}