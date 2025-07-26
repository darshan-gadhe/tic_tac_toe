import 'package:flutter/material.dart';

class ScoreBoard extends StatelessWidget {
  final int scoreX;
  final int scoreO;

  const ScoreBoard({
    super.key,
    required this.scoreX,
    required this.scoreO,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildScoreCard('Player (X)', scoreX, const Color(0xFF31C3BD)),
        _buildScoreCard('Player (O)', scoreO, const Color(0xFFF2B137)),
      ],
    );
  }

  Widget _buildScoreCard(String title, int score, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 8),
        Text(score.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }
}