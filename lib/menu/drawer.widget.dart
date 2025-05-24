import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDrawer extends StatelessWidget {
  final VoidCallback onLogout; // 🔹 Callback pour déconnexion

  MyDrawer({Key? key, required this.onLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.white, Colors.blue]),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("images/sameh.jpg"),
                  radius: 40,
                ),
                SizedBox(height: 10),
                Text(
                  user?.email ?? "Utilisateur inconnu",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ),
          _buildDrawerItem(context, 'Accueil', Icons.home, '/home'),
          _buildDrawerItem(context, 'Météo', Icons.wb_sunny, '/meteo'),
          _buildDrawerItem(context, 'Galerie', Icons.image, '/gallerie'),
          _buildDrawerItem(context, 'Pays', Icons.public, '/pays'),
          _buildDrawerItem(context, 'Contact', Icons.contact_mail, '/contact'),
          _buildDrawerItem(context, 'Paramètre', Icons.settings, '/parametre'),
          _buildDrawerItem(context, 'Prière', Icons.access_time, '/priere'),

          Divider(height: 4, color: Colors.blue),

          ListTile(
            title: Text('Déconnexion', style: TextStyle(fontSize: 22)),
            leading: Icon(Icons.exit_to_app, color: Colors.blue),
            trailing: Icon(Icons.arrow_right, color: Colors.blue),
            onTap: onLogout, // 🔹 Appel du callback
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, IconData icon, String route) {
    return ListTile(
      title: Text(title, style: TextStyle(fontSize: 22)),
      leading: Icon(icon, color: Colors.blue),
      trailing: Icon(Icons.arrow_right, color: Colors.blue),
      onTap: () {
        Navigator.pop(context); // Fermer le drawer
        Navigator.pushNamed(context, route); // Aller à la page
      },
    );
  }
}
