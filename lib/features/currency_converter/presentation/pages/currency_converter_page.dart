import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/currency_list.dart';
import '../../../../core/utils/validators.dart';
import '../../../../widgets/loading_overlay.dart';
import '../../data/services/exchange_rate_service.dart';
import '../../presentation/widgets/amount_input.dart';
import '../../presentation/widgets/convert_button.dart';
import '../../presentation/widgets/currency_dropdown.dart';
import '../../presentation/widgets/quick_conversion.dart';
import '../../presentation/widgets/result_card.dart';
import '../../presentation/widgets/swap_button.dart';

class CurrencyConverterPage extends StatefulWidget {

  final String? initialFrom;
  final String? initialTo;
  
  const CurrencyConverterPage({
    super.key,
    this.initialFrom,
    this.initialTo,
  });

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  late StreamSubscription<InternetConnectionStatus> subscription;

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

  double result = 0;
  bool isLoading = false;
  bool isDarkMode = false;
  bool isOffline = false;
  String? _selectedCountry1;
  String? _selectedCountry2;
  List<String> recentConversions = [];


///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

  //Quick convert variables :
  Future<void> saveLastConversion() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> history = prefs.getStringList('conversion_history') ?? [];

    String newEntry =
        "${_selectedCountry1}_${_selectedCountry2}_${textEditingController.text}";

    // Remove duplicate if exists
    history.remove(newEntry);

    // Add latest at top
    history.insert(0, newEntry);

    // Keep only last 3
    if (history.length > 3) {
      history = history.sublist(0, 3);
    }

    await prefs.setStringList('conversion_history', history);
  }

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

  Future<void> loadRecentConversions() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      recentConversions = prefs.getStringList('conversion_history') ?? [];
    });
  }

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

  String? lastFrom;
  String? lastTo;
  String? lastAmount;

  @override
  void initState() {
    super.initState();
    _CurrencyConverterPageState;

    _selectedCountry1 = widget.initialFrom;

    _selectedCountry2 = widget.initialTo;

    _checkConnection(); // ✅ initial state

    subscription =
        InternetConnectionChecker.instance.onStatusChange.listen((status) {
      setState(() {
        isOffline = status == InternetConnectionStatus.disconnected;
      });
    });

    loadRecentConversions();
  }


///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

  Future<void> _checkConnection() async {
    bool hasInternet = await InternetConnectionChecker.instance.hasConnection;

    setState(() {
      isOffline = !hasInternet;
    });
    loadLastConversion();
  }

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

  Future<void> loadLastConversion() async {
    final pref = await SharedPreferences.getInstance();

    setState(() {
      lastFrom = pref.getString('last_from');
      lastTo = pref.getString('last_to');
      lastAmount = pref.getString('last_amount');
    });
  }

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

  final textEditingController = TextEditingController();

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

  final ExchangeRateService _service = ExchangeRateService();

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

  Future<void> fetchExchangeRate() async {
    final currencyError =
        Validators.validateCurrencies(_selectedCountry1, _selectedCountry2);
    final amountError = Validators.validateAmount(textEditingController.text);
    if (currencyError != null) {
      _showSnackBar(currencyError);
    }

    if (amountError != null) {
      _showSnackBar(amountError);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      bool hasInternet = await InternetConnectionChecker.instance.hasConnection;
      if (!hasInternet) {
        //No internet connection
        setState(() {
          isOffline = true;
          isLoading = false;
        });
        _showSnackBar(
            'No internet connection. Please check your connection and try again.');
        return;
      }

      setState(() {
        isOffline = false;
      });

      final rate = await _service.fetchRate(
        from: _selectedCountry1!,
        to: _selectedCountry2!,
      );

      setState(() {
        result = double.parse(textEditingController.text) * rate;
      });

      await saveLastConversion();
      await loadRecentConversions();
    } catch (e) {
      _showSnackBar('Error Occurred! Try again after some time.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

  //  DARK MODE
  //  ===================================

  void _toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

  Future<void> _toggleFavoritePair() async {
    if (_selectedCountry1 == null || _selectedCountry2 == null) {
      _showSnackBar('Select currencies first');
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    List<String> favorites = prefs.getStringList('favorite_pairs') ?? [];

    String pair = '${_selectedCountry1}_${_selectedCountry2}';

    if (favorites.contains(pair)) {
      _showSnackBar('Already in favourites');
      return;
    }

    favorites.add(pair);

    await prefs.setStringList(
      'favorite_pairs',
      favorites,
    );

    _showSnackBar('Added to favourites');
  }

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

  // ===============================
  // FORMAT NUMBER
  // ===============================

  String formatNumber(dynamic value) {
    final number = value is String ? double.tryParse(value) ?? 0 : value;
    final formatter = NumberFormat('#,###.##');
    return formatter.format(number);
  }

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

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

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

  // ********************          U  I          *************************************

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

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

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.blueGrey,

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
//
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
///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

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

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: isDarkMode ? Colors.white60 : Colors.black,
              size: 30,
            ),
            onPressed: _toggleDarkMode,
          ),

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

          Icon(
            Icons.circle,
            size: 25,
            color: isOffline ? Colors.red : Colors.green,
          ),

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

          const SizedBox(width: 6),
        ],
      ),

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

      body: LoadingOverlay(
        isLoading: isLoading,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

              const SizedBox(height: 60),

              ResultCard(
                label: _selectedCountry1 ?? 'FROM',
                value: textEditingController.text.isEmpty
                    ? '0'
                    : formatNumber(
                        textEditingController.text,
                      ),
              ),

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

              SizedBox(height: 30),

              ResultCard(
                label: _selectedCountry2 ?? 'TO',
                value: result != 0 ? formatNumber(result) : '0',
              ),

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

              const SizedBox(height: 40),

              AmountInput(
                controller: textEditingController,
                isDarkMode: isDarkMode,
                border: border,
              ),

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

              SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color.fromARGB(255, 123, 83, 83).withOpacity(0.04)
                      : const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDarkMode ? Colors.white24 : Colors.black12,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FROM',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDarkMode
                                  ? const Color.fromARGB(179, 201, 103, 103)
                                  : Colors.black54,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: isDarkMode
                                  ? Colors.white.withOpacity(0.03)
                                  : Colors.grey.withOpacity(0.08),
                            ),
                            child: CurrencyDropdown(
                              selectedValue: _selectedCountry1,
                              currencies: currencies,
                              color: isDarkMode ? Colors.amber : Colors.blue,
                              hintText: 'FROM',
                              onChanged: (value) {
                                if (value == _selectedCountry2) {
                                  _showSnackBar(
                                      'Please select different currencies');
                                } else {
                                  setState(() {
                                    _selectedCountry1 = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                              final temp = _selectedCountry1;
                              _selectedCountry1 = _selectedCountry2;
                              _selectedCountry2 = temp;
                            });

                            fetchExchangeRate();
                          },
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: _toggleFavoritePair,
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDarkMode
                                  ? const Color.fromARGB(255, 222, 172, 172)
                                      .withOpacity(0.03)
                                  : Colors.grey.withOpacity(0.08),
                              border: Border.all(
                                color: Colors.amber.withOpacity(0.8),
                                width: 1.2,
                              ),
                            ),
                            child: const Icon(
                              Icons.star_border,
                              color: Colors.amber,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TO',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isDarkMode
                                  ? const Color.fromARGB(179, 228, 101, 101)
                                  : Colors.black54,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: isDarkMode
                                  ? Colors.white.withOpacity(0.03)
                                  : Colors.grey.withOpacity(0.08),
                            ),
                            child: CurrencyDropdown(
                              selectedValue: _selectedCountry2,
                              currencies: currencies,
                              color: isDarkMode ? Colors.amber : Colors.blue,
                              hintText: 'TO',
                              onChanged: (value) {
                                if (value == _selectedCountry1) {
                                  _showSnackBar(
                                      'Please select different currencies');
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
                    ),
                  ],
                ),
              ),

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

              const SizedBox(height: 15),

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

              Column(
                children: [
                  ConvertButton(
                    isDarkMode: isDarkMode,
                    onPressed: () {
                      if (_selectedCountry1 == null ||
                          _selectedCountry2 == null) {
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

                  const SizedBox(height: 16),

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

                  QuickConversionBox(
                    recentConversions: recentConversions,
                    isDarkMode: isDarkMode,
                    onTap: (from, to, amount) {
                      setState(() {
                        _selectedCountry1 = from;
                        _selectedCountry2 = to;
                        textEditingController.text = amount;
                      });
                    },
                  ),

///////////////////**************////////////////***************/////////////////&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
