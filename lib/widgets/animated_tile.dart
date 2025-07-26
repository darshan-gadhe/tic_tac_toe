import 'package:flutter/material.dart';

class AnimatedTile extends StatelessWidget {
  final String symbol; // 'X', 'O', or ''
  final VoidCallback onTap;
  final Color xColor;
  final Color oColor;
  final double fontSize;

  const AnimatedTile({
    super.key,
    required this.symbol,
    required this.onTap,
    required this.xColor,
    required this.oColor,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent, // Makes the whole area tappable
        child: Center(
          // AnimatedSwitcher handles the animation between an empty and a filled tile.
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              // This creates a "pop" or "scale-up" effect.
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              // The key is crucial. It tells AnimatedSwitcher that the widget
              // has changed (from empty to 'X' or 'O'), triggering the animation.
              symbol,
              key: ValueKey<String>(symbol),
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: symbol == 'X' ? xColor : oColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}