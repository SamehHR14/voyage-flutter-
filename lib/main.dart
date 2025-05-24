import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voyage/pages/authentification.page.dart';
import 'package:voyage/pages/contact.page.dart';
import 'package:voyage/pages/galerie.details.dart';
import 'package:voyage/pages/home.page.dart';
import 'package:voyage/pages/inscription.page.dart';
import 'package:voyage/pages/gallerie.page.dart';
import 'package:voyage/pages/meteo.page.dart';
import 'package:voyage/pages/parametre.page.dart';
import 'package:voyage/pages/pays.page.dart';
import 'package:voyage/pages/priere.page.dart';
import 'firebase_options.dart';
// Assurez-vous que ce fichier a été généré pour Firebase

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = {
    '/home': (context) => HomePage(),
    '/inscription': (context) => InscriptionPage(),
    '/authentification': (context) => AuthentificationPage(),
    '/contact': (context) => ContactPage(),
    '/gallerie': (context) => GalleriePage(),
    '/parametre': (context) => ParametresPage(),
    '/pays': (context) => PaysPage(),
    '/meteo': (context) => MeteoPage(),
    '/priere': (context) => PrierePage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: routes,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());  // Affichage d'un indicateur de chargement
          } else if (snapshot.hasData) {
            return HomePage();  // Si l'utilisateur est authentifié
          } else {
            return AuthentificationPage();  // Si l'utilisateur n'est pas authentifié
          }
        },
      ),
    );
  }
}
