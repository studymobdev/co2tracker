import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/authenticate/authenticate.dart';
import 'package:flutter_application_1/screens/authenticate/sign_in.dart';
import 'package:flutter_application_1/screens/settings/settings.dart';
import 'package:flutter_application_1/screens/wrap.dart';
import 'package:flutter_application_1/services/auth.dart';

class NavigationDrawerWidget extends StatelessWidget {
  NavigationDrawerWidget({Key? key}) : super(key: key);
  final padding = EdgeInsets.symmetric(horizontal: 20);
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Color.fromARGB(200, 22, 99, 227),
        child: ListView(padding: padding, children: <Widget>[
          SizedBox(height: 50),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text('My Profile', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
          SizedBox(height: 20),
          Divider(color: Colors.white70),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.white),
            title: Text('Logout', style: TextStyle(color: Colors.white)),
            onTap: () async {
              await _auth.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/wrapper', (_) => false);
            },
          )
        ]),
      ),
    );
  }
}
