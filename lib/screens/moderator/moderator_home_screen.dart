import 'package:flutter/material.dart';
import 'package:gcma_v1/services/auth_service.dart';

import 'package:provider/provider.dart';

class ModeratorHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Moderator Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _authService.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome Moderator'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to the moderator dashboard
              },
              child: Text('Moderator Dashboard'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the content management page
              },
              child: Text('Content Management'),
            ),
          ],
        ),
      ),
    );
  }
}
