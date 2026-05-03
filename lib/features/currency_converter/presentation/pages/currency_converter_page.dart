import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/intl.dart';
import '../../../../widgets/loading_overlay.dart';
import '../../../../core/utils/currency_list.dart';
import '../../data/services/exchange_rate_service.dart';
import '../../presentation/widgets/result_card.dart';
import '../../presentation/widgets/currency_dropdown.dart';
import '../../presentation/widgets/amount_input.dart';
import '../../presentation/widgets/swap_button.dart';
import '../../presentation/widgets/convert_button.dart';
import '../../../../core/utils/validators.dart';

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

  final ExchangeRateService _service = ExchangeRateService();

  Future<void> fetchExchangeRate() async {
    final currencyError = Validators.validateCurrencies(_selectedCountry1, _selectedCountry2);
    final amountError = Validators.validateAmount(textEditingController.text);
    if (currencyError != null) { _showSnackBar(currencyError); }

    if (amountError != null) {
      _showSnackBar(amountError);
      return;
    }

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
      
      final rate = await _service.fetchRate(
        from: _selectedCountry1!,
        to: _selectedCountry2!,
      );
      
      setState(() {
        result = double.parse(textEditingController.text) * rate;
      });

    } catch (e) {
      _showSnackBar(
        'Error Occurred! Try again after some time.'
      );

    } finally {

      setState(() {
        isLoading = false;
      });
    }
  }

  //  ===================================
  //  DARK MODE
  //  ===================================

  void _toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  // ===============================
  // FORMAT NUMBER
  // ===============================

  String formatNumber(dynamic value) {
    final number = value is String ? double.tryParse(value) ?? 0 : value;
    final formatter = NumberFormat('#,###.##');
    return formatter.format(number);
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


  // =====================================************************===============================================
  // UI
  // =====================================************************===============================================



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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              ResultCard(
                label: _selectedCountry1 ?? 'FROM',
                value: textEditingController.text.isEmpty
                    ? '0'
                    : formatNumber(
                        textEditingController.text,
                      ),
              ),
              SizedBox(height: 30),
              ResultCard(
                label: _selectedCountry2 ?? 'TO',
                value: result != 0 ? formatNumber(result) : '0',
              ),
              const SizedBox(height: 40),
              AmountInput(
                controller: textEditingController,
                isDarkMode: isDarkMode,
                border: border,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // First Dropdown
                  Expanded(
                    child: CurrencyDropdown(
                      selectedValue: _selectedCountry1,
                      currencies: currencies,
                      hintText: 'FROM',
                      onChanged: (value) {
                        if (value == _selectedCountry2) {
                          _showSnackBar('Please select different currencies');
                        } else {
                          setState(() {
                            _selectedCountry1 = value;
                          });
                        }
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Swap Button
                  SwapButton(
                    isDarkMode: isDarkMode,
                    onPressed: () {
                      if (_selectedCountry1 == null ||
                          _selectedCountry2 == null) {
                        _showSnackBar('Select From & To Currencies');
                        return;
                      }

                      if (textEditingController.text.isEmpty ||
                          textEditingController.text == '0') {
                        _showSnackBar('Enter amount!');
                        return;
                      }

                      setState(() {
                        String? temp = _selectedCountry1;
                        _selectedCountry1 = _selectedCountry2;
                        _selectedCountry2 = temp;
                      });

                      fetchExchangeRate();
                    },
                  ),

                  const SizedBox(width: 10),

                  // Second Dropdown
                  Expanded(
                    child: CurrencyDropdown(
                      selectedValue: _selectedCountry2,
                      currencies: currencies,
                      hintText: 'TO',
                      onChanged: (value) {
                        if (value == _selectedCountry1) {
                          _showSnackBar('Please select different currencies');
                        } else {
                          setState(() {
                            _selectedCountry2 = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              ConvertButton(
                isDarkMode: isDarkMode,
                onPressed: () {
                  if (_selectedCountry1 == null || _selectedCountry2 == null) {
                    _showSnackBar('Select From & To Currencies');
                    return;
                  }

                  if (textEditingController.text.isEmpty) {
                    _showSnackBar('Enter amount!');
                    return;
                  }

                  fetchExchangeRate();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
