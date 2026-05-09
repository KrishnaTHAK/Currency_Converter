import 'package:flutter/material.dart';
import 'currency_converter_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {

  Future<List<String>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(
          'favorite_pairs',
        ) ??
        [];
  }

  Future<void> removeFavorite(
    int index,
    List<String> favoritePairs,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    favoritePairs.removeAt(index);

    await prefs.setStringList(
      'favorite_pairs',
      favoritePairs,
    );

    setState(() {});
  }

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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: FutureBuilder<List<String>>(
                future: loadFavorites(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final favoritePairs = snapshot.data!;

                  if (favoritePairs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Favourite Currencies',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: favoritePairs.length,
                    itemBuilder: (context, index) {
                      final pair = favoritePairs[index];

                      final parts = pair.split('_');

                      final from = parts[0];

                      final to = parts[1];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CurrencyConverterPage(
                                    initialFrom: from,
                                    initialTo: to,
                                  ),
                                ),
                              );
                            },
                            leading: const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            title: Text(
                              '$from → $to',
                            ),
                            subtitle: const Text(
                              'Tap to use quickly',
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                removeFavorite(
                                  index,
                                  favoritePairs,
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}