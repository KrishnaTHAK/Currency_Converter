import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({required this.isLoading, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child, // Your main UI stays in the background
        if (isLoading)...[
          Positioned.fill(
            child: Container(
              color:
                  Colors.black.withOpacity(0.3), // Semi-transparent background
              child: Center(
                child: CircularProgressIndicator(), // Spinning loader
              ),
            ),
          ),
        ],
      ],
    );
  }
}
