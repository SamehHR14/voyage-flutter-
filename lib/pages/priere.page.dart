import 'package:flutter/material.dart';
import 'prière-details.page.dart';


class PrierePage extends StatefulWidget {
  @override
  _PrierePageState createState() => _PrierePageState();
}

class _PrierePageState extends State<PrierePage> {
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Horaires de prière')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'Ville'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _countryController,
              decoration: InputDecoration(labelText: 'Pays'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final city = _cityController.text;
                final country = _countryController.text;
                if (city.isNotEmpty && country.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PriereDetailsPage(
                        city: city,
                        country: country,
                      ),
                    ),
                  );
                }
              },
              child: Text('Afficher les prières'),
            ),
          ],
        ),
      ),
    );
  }
}
