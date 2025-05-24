import 'package:flutter/material.dart';
import 'galerie.details.dart'; // Assure-toi que le fichier est bien dans le même dossier ou adapte le chemin

class GalleriePage extends StatefulWidget {
  @override
  _GalleriePageState createState() => _GalleriePageState();
}

class _GalleriePageState extends State<GalleriePage> {
  final TextEditingController _controller = TextEditingController();

  void _handleSearch() {
    final keyword = _controller.text.trim();
    if (keyword.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GallerieDetailsPage(message: keyword),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page Gallerie')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Keyword',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleSearch,
              child: Text('Chercher'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
