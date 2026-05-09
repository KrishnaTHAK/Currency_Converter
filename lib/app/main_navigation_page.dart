import 'package:flutter/material.dart';

import '../features/currency_converter/presentation/pages/charts_page.dart';
import '../features/currency_converter/presentation/pages/currency_converter_page.dart';
import '../features/currency_converter/presentation/pages/favourites_page.dart';
import '../features/currency_converter/presentation/pages/history_page.dart';
import '../features/currency_converter/presentation/pages/settings_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPage();
}

class _MainNavigationPage extends State<MainNavigationPage> {
  int _selectIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const CurrencyConverterPage();

      case 1:
        return const ChartsPage();

      case 2:
        return const FavouritesPage();

      case 3:
        return const HistoryPage();

      case 4:
        return const SettingsPage();

      default:
        return const CurrencyConverterPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_selectIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectIndex,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: "Convert",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: "Charts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Favourites",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
