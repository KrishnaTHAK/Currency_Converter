import 'package:flutter/material.dart';

class CurrencyDropdown extends StatelessWidget {
  final String? selectedValue;
  final List<String> currencies;
  final Function(String?) onChanged;
  final String hintText;
  
  const CurrencyDropdown({
    super.key,
    required this.selectedValue,
    required this.currencies,
    required this.onChanged,
    required this.hintText
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      hint: Text(
        hintText,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      dropdownColor: Colors.grey,
      isExpanded: true,
      items: currencies.map((String country) {
        return DropdownMenuItem<String>(
          value: country,
          child: Text(country),
        );
      }).toList(),
      onChanged: onChanged,
      selectedItemBuilder: (context) {
        return currencies.map((String country) {
          return Text(
            country,
            style: const TextStyle(
              color: Colors.white60,
            ),
          );
        }).toList();
      },
    );
  }
}
