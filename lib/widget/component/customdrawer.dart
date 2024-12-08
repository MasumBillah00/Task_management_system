
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../screens/login_registration/loginpage.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Text("TMS")),
          const ListTile(title: Text("Item 1")),
          const ListTile(title: Text("Item 2")),
          const ListTile(title: Text("Item 3")),
          ListTile(
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) =>  LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
