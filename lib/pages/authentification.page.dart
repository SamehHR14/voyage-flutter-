import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthentificationPage extends StatefulWidget {
  @override
  _AuthentificationPageState createState() => _AuthentificationPageState();
}

class _AuthentificationPageState extends State<AuthentificationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mdpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String? _erreur;

  void _onAuthentifier() async {
    setState(() {
      _isLoading = true;
      _erreur = null;
    });

    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _mdpController.text,
      );

      // ✅ Connexion réussie
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      // ❌ Gestion des erreurs Firebase
      setState(() {
        if (e.code == 'user-not-found') {
          _erreur = 'Aucun utilisateur trouvé avec cet email.';
        } else if (e.code == 'wrong-password') {
          _erreur = 'Mot de passe incorrect.';
        } else {
          _erreur = 'Erreur : ${e.message}';
        }
      });
    } catch (e) {
      setState(() {
        _erreur = 'Une erreur est survenue. Veuillez réessayer.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _mdpController,
              decoration: InputDecoration(labelText: "Mot de passe"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            if (_erreur != null)
              Text(_erreur!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 10),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _onAuthentifier,
              child: Text("Se connecter"),
            ),
          ],
        ),
      ),
    );
  }
}
