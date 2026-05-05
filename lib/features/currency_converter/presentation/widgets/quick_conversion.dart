import 'package:flutter/material.dart';

class QuickConversionBox extends StatelessWidget {
  final List<String> recentConversions;
  final bool isDarkMode;
  final void Function(String from, String to, String amount) onTap;

  const QuickConversionBox({
    super.key,
    required this.recentConversions,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkMode ? Colors.white.withOpacity(0.08) : Colors.white;
    final borderColor = isDarkMode ? Colors.white24 : Colors.black12;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final faintColor = isDarkMode ? Colors.white38 : Colors.black38;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Conversion',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          if (recentConversions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'No History',
                style: TextStyle(
                  color: faintColor,
                  fontSize: 14,
                ),
              ),
            )
          else
            Column(
              children: recentConversions.take(3).map((item) {
                final parts = item.split('_');
                final from = parts.isNotEmpty ? parts[0] : '';
                final to = parts.length > 1 ? parts[1] : '';
                final amount = parts.length > 2 ? parts[2] : '';

                return Padding(
                  padding: const EdgeInsets.only(bottom:20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => onTap(from, to, amount),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.05)
                            : Colors.black.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$from → $to   •   $amount',
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
