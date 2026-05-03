class Validators {
  
  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter amount!';
    }

    final number = double.tryParse(value);

    if (number == null) {
      return 'Enter valid number!';
    }

    if (number <= 0) {
      return 'Amount must be greater than 0!';
    }

    return null;
  }

  // Validate currency selection
  static String? validateCurrencies(
    String? from,
    String? to,
  ) {
    if (from == null || to == null) {
      return 'Select From & To Currencies';
    }

    if (from == to) {
      return 'Please select different currencies';
    }

    return null;
  }
}
