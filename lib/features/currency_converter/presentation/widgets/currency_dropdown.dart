import 'package:flutter/material.dart';

class CurrencyDropdown extends StatelessWidget {
  final String? selectedValue;
  final List<String> currencies;
  final Function(String?) onChanged;
  final String hintText;
  final Color color;
  
  const CurrencyDropdown({
    super.key,
    required this.selectedValue,
    required this.currencies,
    required this.onChanged,
    required this.hintText,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      hint: Text(
        hintText,
        style: TextStyle(
          color: color,
          fontSize: 18,
          fontWeight: FontWeight.w600,
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
              color: Color.fromARGB(153, 119, 102, 243),
            ),
          );
        }).toList();
      },
    );
  }
}
