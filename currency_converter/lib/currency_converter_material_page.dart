import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';

class CurrencyConverterMaterialPage extends StatefulWidget {
  const CurrencyConverterMaterialPage({super.key});

  @override
  State<CurrencyConverterMaterialPage> createState() =>
      _CurrencyConverterMaterialPageState();
}

class _CurrencyConverterMaterialPageState
    extends State<CurrencyConverterMaterialPage> {
  double result = 0;
  final textEditingController = TextEditingController();

  String? _selectedCountry1;
  String? _selectedCountry2;
  final List<String> _countries = [
    'AFN', // - AFGHANISTAN (ASIA),
    'INR', // - INDIA (ASIA)
    'JPY', // - JAPAN (ASIA)
    'CNY', // - CHINA (ASIA)
    'KRW', // SOUTH KOREA (ASIA)
    'IDR', // - INDONESIA (ASIA)
    'IRR', // - IRAN (ASIA)',
    'THB', // - THAILAND (ASIA)',
    'TRY', // - TURKEY (ASIA)',
    'USD', // - UNITED STATES (NORTH AMERICA)',
    'GBP', // - UNITED KINGDOM (EUROPE)',
    'CAD', // - CANADA (NORTH AMERICA, EUROPE)',
    'EUR', // - ITALY (EUROPE)',
    'CHF', // - SWITZERLAND (EUROPE)',
    'SEK', // - SWEDEN (EUROPE)',
    'PLN', // - POLAND (EUROPE)',
    'NOK', // - NORWAY (EUROPE)',
    'RUB', // - RUSSIA (EUROPE)',
    'BRL', // - BRAZIL (SOUTH AMERICA)',
    'ZAR', // - SOUTH AFRICA (AFRICA)',
    'MXN', // - MEXICO (CENTRAL AMERICA)',
    'SAR', // - SAUDI ARABIA (MIDDLE EAST)',
    'ARS', // - ARGENTINA (SOUTH AMERICA)',
    'AUD', // - AUSTRALIA (OCEANIA)',
    'NZD', // - NEW ZEALAND (OCEANIA)',
    'AED', // - UNITED ARAB EMIRATES (MIDDLE EAST)',
    'EGP', // - EGYPT (AFRICA)',
  ];
  Future<void> fetchExchangeRate() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      //No internet connection
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No internet connection. Please check your connection and try again.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'SegoeScript',
            ),
          ),
          duration: Duration(seconds: 5),
        ),
      );
      return;
    }

    try {
      if (_selectedCountry1 != null &&
          _selectedCountry2 != null &&
          textEditingController.text.isNotEmpty) {
        final response = await http.get(Uri.parse(
            'https://v6.exchangerate-api.com/v6/81dab1317f9663d1c23fc256/latest/$_selectedCountry1'));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final double rate = data['conversion_rates'][_selectedCountry2];
          setState(() {
            result = double.parse(textEditingController.text) * rate;
          });
        } else {
          throw Exception('Failed to load data');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('Error: Please check you internet connection and try again.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build fn');

    final border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 2.0,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.circular(10.00),
    );

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 1,
        title: const Text(
          'Currency Converter!',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'SegoeScript',
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_selectedCountry1 ?? 'FROM'} ${textEditingController.text == '' ? '0' : textEditingController.text}',
              style: const TextStyle(
                fontFamily: 'SegoeScript',
                fontSize: 35,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Text(
              '${_selectedCountry2 ?? 'TO'} ${result != 0 ? result.toStringAsFixed(2) : result.toStringAsFixed(0)}',
              style: const TextStyle(
                fontFamily: 'SegoeScript',
                fontSize: 35,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: textEditingController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Please enter the amount',
                  hintStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  prefixIcon: const Icon(Icons.monetization_on_sharp),
                  prefixIconColor: Colors.black,
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: border,
                  enabledBorder: border,
                ),
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //___button____1
                DropdownButton<String>(
                  value: _selectedCountry1,
                  hint: const Text(
                    'FROM',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  dropdownColor: Colors.grey,
                  items: _countries.map((String country) {
                    return DropdownMenuItem<String>(
                        value: country, child: Text(country));
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedCountry1 = value;
                    });
                  },
                ),
                const SizedBox(width: 40),
                //___button____2
                DropdownButton<String>(
                  value: _selectedCountry2,
                  hint: Text(
                    'TO',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  dropdownColor: Colors.grey,
                  items: _countries.map((country) {
                    return DropdownMenuItem(
                        value: country, child: Text(country));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCountry2 = newValue;
                    });
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                onPressed: () {
                  fetchExchangeRate();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text('Convert'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
  
  // The above code is a simple currency converter app that converts one currency to another. The app uses the  exchangerate-api.com API to fetch the exchange rate. The app has two dropdown buttons to select the currency to convert from and to. The user can enter the amount to convert in the text field. When the user clicks the convert button, the app fetches the exchange rate and displays the converted amount. 
  // The app uses the  Connectivity plugin to check the internet connection. If there is no internet connection, the app shows a snackbar message. 
  // The app uses the  http package to make an HTTP request to the API. The app fetches the exchange rate and calculates the converted amount. 
  // The app uses the  json package to parse the JSON response from the API. 
  // The app uses the  TextEditingController to get the text entered by the user in the text field. 
  // The app uses the  DropdownButton widget to create dropdown buttons for selecting the currency. 
  // The app uses the  TextButton widget to create a button to convert the currency. 
  // The app uses the  SnackBar widget to show a message when there is an error. 
  // The app uses the  Scaffold widget to create the layout of the app. 
  // The app uses the  AppBar widget to create the app bar. 
  // The app uses the  Column widget to arrange the widgets in a column. 
  // The app uses the  Row widget to arrange the widgets in a row. 
  // The app uses the  Padding widget to add padding around the widgets. 
  // The app uses the  TextStyle widget to style the text. 
  // The app uses the  InputDecoration widget to style the text field. 
  // The app uses the  OutlineInputBorder widget to create a border around the text field. 
  // The app uses the  BeveledRectangleBorder widget to create a beveled rectangle border around the button. 
  // The app uses the  Text widget to display text. 
  // The app uses the  Icon widget to display an icon. 
  // The app uses the  SizedBox widget to add space between the widgets. 
  // The app uses the  Center widget to center the widgets. 
  // The app uses the  MainAxisAlignment widget to align the widgets along the main axis. 
  // The app uses the  CrossAxisAlignment widget to align the widgets along the cross axis. 
  // The app uses the  FutureBuilder widget to build the UI based on the future value. 
  // The app uses the  setState method to update the UI when the state changes.