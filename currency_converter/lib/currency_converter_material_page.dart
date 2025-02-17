import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/intl.dart';
import 'widgets/loading_overlay.dart';

class CurrencyConverterMaterialPage extends StatefulWidget {
  const CurrencyConverterMaterialPage({super.key});

  @override
  State<CurrencyConverterMaterialPage> createState() =>
      _CurrencyConverterMaterialPageState();
}

class _CurrencyConverterMaterialPageState
    extends State<CurrencyConverterMaterialPage> {
  bool isLoading = false;
  double result = 0;
  bool isDarkMode = false;
  String? _selectedCountry1;
  String? _selectedCountry2;

  final textEditingController = TextEditingController();

  final List<String> _countries = [
    'AFN',
    'ALL',
    'AMD',
    'ANG',
    'AOA',
    'ARS',
    'AUD',
    'AZN',
    'BAM',
    'BBD',
    'BDT',
    'BGN',
    'BIF',
    'BND',
    'BOB',
    'BRL',
    'BTN',
    'BYN',
    'BZD',
    'CAD',
    'CHF',
    'CLP',
    'CNY',
    'COP',
    'CRC',
    'CUP',
    'CVE',
    'CZK',
    'DJF',
    'DKK',
    'DOP',
    'DZD',
    'EGP',
    'ETB',
    'EUR',
    'FJD',
    'GBP',
    'GEL',
    'GHS',
    'GIP',
    'GMD',
    'GNF',
    'GTQ',
    'GYD',
    'HKD',
    'HNL',
    'HTG',
    'HUF',
    'IDR',
    'ILS',
    'INR',
    'IQD',
    'IRR',
    'ISK',
    'JMD',
    'JOD',
    'JPY',
    'KES',
    'KGS',
    'KRW',
    'KWD',
    'KZT',
    'LAK',
    'LBP',
    'LRD',
    'LSL',
    'LYD',
    'MAD',
    'MDL',
    'MGA',
    'MKD',
    'MMK',
    'MNT',
    'MOP',
    'MRU',
    'MUR',
    'MVR',
    'MWK',
    'MXN',
    'MYR',
    'MZN',
    'NAD',
    'NGN',
    'NIO',
    'NOK',
    'NPR',
    'NZD',
    'OMR',
    'PAB',
    'PEN',
    'PGK',
    'PHP',
    'PKR',
    'PLN',
    'PYG',
    'QAR',
    'RON',
    'RUB',
    'RWF',
    'SAR',
    'SBD',
    'SCR',
    'SDG',
    'SEK',
    'SGD',
    'SOS',
    'SRD',
    'SSP',
    'SZL',
    'SYP',
    'THB',
    'TJS',
    'TMT',
    'TND',
    'TOP',
    'TRY',
    'TTD',
    'TWD',
    'TZS',
    'UAH',
    'UGX',
    'USD',
    'UYU',
    'UZS',
    'VES',
    'VND',
    'XOF',
    'YER',
    'ZAR',
    'ZMW',
    'ZWL',
  ];

  Future<void> fetchExchangeRate() async {
    setState(() {
      isLoading = true;
    });

    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        //No internet connection
        _showSnackBar(
            'No internet connection. Please check your connection and try again.');
        setState(() {
          isLoading = false;
        });
        return;
      }
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
      _showSnackBar('Error Occurred! Try again after some time.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  String formatNumber(dynamic value) {
    final number = value is String ? double.tryParse(value) ?? 0 : value;
    final formatter = NumberFormat('#,###.##');
    return formatter.format(number);
  }

  void printError() {
    _showSnackBar('Please select different currencies');
    return;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontFamily: "SegoeScript"),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      ),
    );
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
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.blueGrey,
        elevation: 1,
        title: AutoSizeText(
          'Currency Converter!',
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.white,
            fontSize: 20,
            fontFamily: 'SegoeScript',
          ),
          maxLines: 1,
        ),
        // centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.replay_circle_filled,
              color: isDarkMode ? Colors.white70 : Colors.black,
              size: 30,
            ),
            onPressed: () => setState(() {
              _selectedCountry1 = null;
              _selectedCountry2 = null;
              textEditingController.text = "0";
              result = 0;
            }),
          ),
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: isDarkMode ? Colors.white60 : Colors.black,
              size: 30,
            ),
            onPressed: _toggleDarkMode,
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: LoadingOverlay(
        isLoading: isLoading,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            AutoSizeText(
              //FROM
              '${_selectedCountry1 ?? 'FROM'} ${textEditingController.text == '' ? '0' : formatNumber(textEditingController.text)}',
              style: const TextStyle(
                fontFamily: 'SegoeScript',
                fontSize: 35,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              minFontSize: 10,
              stepGranularity: 1,
            ),
            SizedBox(height: 30),
            AutoSizeText(
              // TO
              '${_selectedCountry2 ?? 'TO'} ${result != 0 ? formatNumber(result) : result.toStringAsFixed(0)}',
              style: const TextStyle(
                fontFamily: 'SegoeScript',
                fontSize: 35,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              minFontSize: 10,
              stepGranularity: 1,
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: textEditingController,
                style: isDarkMode
                    ? TextStyle(color: Colors.black)
                    : TextStyle(color: Colors.white),
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
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
            SizedBox(height: 20),
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
                  onChanged: (String? newValue) {
                    if (newValue == _selectedCountry2) {
                      printError();
                    } else {
                      setState(() {
                        _selectedCountry1 = newValue;
                      });
                    }
                  },
                  selectedItemBuilder: (context) {
                    return _countries.map((String country) {
                      return Text(
                        country,
                        style: const TextStyle(
                          color: Colors.white60,
                        ),
                      );
                    }).toList();
                  },
                ),
                const SizedBox(width: 40),

                //___button___2____Currency_Swap_Button
                IconButton(
                  onPressed: () {
                    if (_selectedCountry1 == null || _selectedCountry2 == null)
                      _showSnackBar('Select From & To Currencies');
                    else if (textEditingController.text.isEmpty ||
                        textEditingController.text == '0') {
                      _showSnackBar('Enter amount!');
                    }
                    setState(() {
                      String? temp = _selectedCountry1;
                      _selectedCountry1 = _selectedCountry2;
                      _selectedCountry2 = temp;
                    });
                    fetchExchangeRate();
                  },
                  icon: Icon(
                    Icons.compare_arrows_rounded,
                    size: 30,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(width: 40),

                //___button____3
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
                    if (newValue == _selectedCountry1) {
                      printError();
                    } else {
                      setState(
                        () {
                          _selectedCountry2 = newValue;
                        },
                      );
                    }
                  },
                  selectedItemBuilder: (context) {
                    return _countries.map((String country) {
                      return Text(
                        country,
                        style: const TextStyle(
                          color: Colors.white60,
                        ),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                onPressed: () {
                  if (_selectedCountry1 == null || _selectedCountry2 == null)
                    _showSnackBar('Select From & To Currencies');
                  else if (textEditingController.text.isEmpty) {
                    _showSnackBar('Enter amount!');
                  } else
                    fetchExchangeRate();
                },
                style: TextButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.white12 : Colors.black,
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