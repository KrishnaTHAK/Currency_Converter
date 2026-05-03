import 'dart:convert';
import 'package:http/http.dart' as http;

class ExchangeRateService {

  Future<double> fetchRate({
    required String from,
    required String to,
  }) async {

    final response = await http.get(
      Uri.parse(
        'https://v6.exchangerate-api.com/v6/81dab1317f9663d1c23fc256/latest/$from',
      ),
    );

    if (response.statusCode == 200) {

      final data = json.decode(response.body);

      return (data['conversion_rates'][to] as num)
          .toDouble();

    } else {
      throw Exception('Failed to load rate');
    }
  }
}