import 'package:flutter/material.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key});

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  String fromCurrency = "USD";
  String toCurrency = "INR";

  String selectedRange = "7D";

  final List<String> ranges = [
    "7D",
    "30D",
    "90D",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historical Charts"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Currency Row

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: fromCurrency,
                    items: const [
                      DropdownMenuItem(
                        value: "USD",
                        child: Text("USD"),
                      ),
                      DropdownMenuItem(
                        value: "INR",
                        child: Text("INR"),
                      ),
                      DropdownMenuItem(
                        value: "EUR",
                        child: Text("EUR"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        fromCurrency = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "From",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: toCurrency,
                    items: const [
                      DropdownMenuItem(
                        value: "INR",
                        child: Text("INR"),
                      ),
                      DropdownMenuItem(
                        value: "USD",
                        child: Text("USD"),
                      ),
                      DropdownMenuItem(
                        value: "EUR",
                        child: Text("EUR"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        toCurrency = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "To",
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Range Selector

            DropdownButtonFormField<String>(
              value: selectedRange,
              items: ranges.map((range) {
                return DropdownMenuItem(
                  value: range,
                  child: Text(range),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRange = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: "Select Range",
              ),
            ),

            const SizedBox(height: 30),

            /// Chart Placeholder

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Chart will appear here",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Load Button

            ElevatedButton(
              onPressed: () {
                print("Load Chart");
              },
              child: const Text("Load Chart"),
            ),
          ],
        ),
      ),
    );
  }
}
