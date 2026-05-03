import 'package:flutter/material.dart';

class SwapButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isDarkMode;

  const SwapButton(
      {super.key, required this.onPressed, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.compare_arrows_rounded,
        size: 30,
        color: isDarkMode ? Colors.white70 : Colors.black87,
      ),
    );
  }
}
