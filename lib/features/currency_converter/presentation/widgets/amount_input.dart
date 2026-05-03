import 'package:flutter/material.dart';

class AmountInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isDarkMode;
  final OutlineInputBorder border;

  const AmountInput(
      {super.key,
      required this.controller,
      required this.isDarkMode,
      required this.border});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: isDarkMode ? Colors.black : Colors.white,
        ),
        decoration: InputDecoration(
          hintText: 'Please enter the amount',
          hintStyle: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.grey,
          ),
          prefixIcon: const Icon(Icons.monetization_on_sharp),
          prefixIconColor: isDarkMode ? Colors.black : Colors.white70,
          filled: true,
          fillColor: isDarkMode ? Colors.white54 : Colors.grey[900],
          focusedBorder: border,
          enabledBorder: border,
        ),
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
      ),
    );
  }
}
