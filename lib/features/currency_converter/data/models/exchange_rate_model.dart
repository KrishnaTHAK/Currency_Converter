class ExchangeRateModel {
  final String baseCode;
  final Map<String, dynamic> conversionRates;

  ExchangeRateModel({
    required this.baseCode,
    required this.conversionRates,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    return ExchangeRateModel(
      baseCode: json['base_code'],
      conversionRates: json['conversion_rates'], // IMPORTANT
    );
  }
}
