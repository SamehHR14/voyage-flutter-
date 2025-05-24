import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../menu/drawer.widget.dart';
import 'package:voyage/config/global.param.dart';

class HomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Home'),
      ),
      drawer: MyDrawer(onLogout: () => _deconnexion(context)), // Passer la déconnexion au drawer
      body: Column(
        children: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Connecté en tant que : ${user.email}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          Expanded(
            child: Center(
              child: Wrap(
                spacing: 20,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ...(GlobalParams.accueil as List).map((item) {
                    return InkWell(
                      child: Ink.image(
                        height: 80,
                        width: 80,
                        image: AssetImage(item['image']),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, item['route']);
                      },
                    );
                  }).toList(),
                  // Autres boutons (meteo, galerie, etc.)
                  _buildIcon(context, 'images/meteo.png', '/meteo'),
                  _buildIcon(context, 'images/galerie.png', '/gallerie'),
                  _buildIcon(context, 'images/pays.png', '/pays'),
                  _buildIcon(context, 'images/contact.png', '/contact'),
                  _buildIcon(context, 'images/parametres.png', '/parametre'),
                  _buildIcon(context, 'images/priere.png', '/priere'),
                  InkWell(
                    child: Ink.image(
                      height: 80,
                      width: 80,
                      image: const AssetImage('images/deconnexion.png'),
                    ),
                    onTap: () {
                      _deconnexion(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(BuildContext context, String image, String route) {
    return InkWell(
      child: Ink.image(
        height: 80,
        width: 80,
        image: AssetImage(image),
      ),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }

  Future<void> _deconnexion(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/authentification', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la déconnexion : $e')),
      );
    }
  }
}
