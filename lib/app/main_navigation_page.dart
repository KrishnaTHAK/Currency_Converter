import 'package:flutter/material.dart';

import '../features/currency_converter/presentation/pages/currency_converter_page.dart';
import '../features/currency_converter/presentation/pages/charts_page.dart';
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

  final List<Widget> _pages = [
    const CurrencyConverterPage(),
    const ChartsPage(),
    const FavouritesPage(),
    const HistoryPage(),
    const SettingsPage()
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: IndexedStack(
        index: _selectIndex,
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _selectIndex,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
        
        items: const [
        
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: "Convert"
          ),
        
          BottomNavigationBarItem(
            icon:Icon(Icons.show_chart),
            label: "Charts"
          ),
        
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Favourites"
          ),
        
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History"
          ),
        
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          )

        ],
      ),
    );
  }
}
