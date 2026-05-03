import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ResultCard extends StatelessWidget{
  final String label;
  final String value;

  const ResultCard({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AutoSizeText(
          "$label $value",
          maxLines: 1,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
