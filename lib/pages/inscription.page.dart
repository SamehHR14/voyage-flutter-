import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class InscriptionPage extends StatelessWidget {
  TextEditingController txt_login = TextEditingController();
  TextEditingController txt_password = TextEditingController();
  late SharedPreferences prefs;

  Future<void> _onInscrire(BuildContext context) async {
    String emailAddress = txt_login.text.trim();
    String password = txt_password.text.trim();

    if (emailAddress.isEmpty || password.isEmpty) {
      const snackBar = SnackBar(content: Text("Identifiant ou mot de passe vide !"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: emailAddress, password: password);

      // Sauvegarder localement avec SharedPreferences
      prefs = await SharedPreferences.getInstance();
      prefs.setString("login", emailAddress);
      prefs.setString("password", password);
      prefs.setBool("connecte", true);

      // Redirection vers la page d'accueil
      Navigator.pop(context);
      Navigator.pushNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String errorMessage = "";
      if (e.code == 'weak-password') {
        errorMessage = 'Le mot de passe est trop faible.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Un compte existe déjà avec cet e-mail.';
      } else {
        errorMessage = 'Erreur : ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur inattendue : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Page Inscription')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  controller: txt_login,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Email",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  obscureText: true,
                  controller: txt_password,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password),
                      hintText: "Mot de passe",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50)),
                    onPressed: () {
                      _onInscrire(context);
                    },
                    child: Text('Inscription', style: TextStyle(fontSize: 22))),
              ),
              TextButton(
                child: const Text("J'ai déjà un compte",
                    style: TextStyle(fontSize: 22)),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/authentification');
                },
              ),
            ],
          ),
        ));
  }
}
