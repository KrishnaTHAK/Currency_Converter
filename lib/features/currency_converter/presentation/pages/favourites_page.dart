import 'package:flutter/material.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saved Currency Pairs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: const [
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.star),
                      title: Text('USD → INR'),
                      subtitle: Text('Tap to use quickly'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.star),
                      title: Text('EUR → INR'),
                      subtitle: Text('Tap to use quickly'),
                      trailing: Icon(Icons.chevron_right),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
