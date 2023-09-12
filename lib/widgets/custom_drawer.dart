import 'package:flutter/material.dart';

enum UserRole { admin, moderator, user }

class CustomDrawer extends StatelessWidget {
  final UserRole userRole;

  const CustomDrawer({required Key key, required this.userRole})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menü',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Ana Sayfa'),
            onTap: () {
              // Ana sayfaya yönlendirme işlemi
            },
          ),
          if (userRole == UserRole.admin || userRole == UserRole.moderator)
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Yönetim Paneli'),
              onTap: () {
                // Yönetim paneline yönlendirme işlemi
              },
            ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Yardım'),
            onTap: () {
              // Yardım sayfasına yönlendirme işlemi
            },
          ),
        ],
      ),
    );
  }
}
