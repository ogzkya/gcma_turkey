import 'package:flutter/material.dart';
import 'package:gcma_v1/screens/login_screen.dart';
import 'package:gcma_v1/screens/user_profile_screen.dart';
import 'package:gcma_v1/services/auth_service.dart';
import 'package:provider/provider.dart';
import '../login_screen.dart';
import 'package:flutter/material.dart';
import 'package:gcma_v1/screens/admin/admin_panel.dart';
import 'package:gcma_v1/screens/user_management.dart';
import 'package:gcma_v1/screens/earthquake.dart';
import 'package:gcma_v1/screens/water_crisis.dart';
import 'package:gcma_v1/screens/climate_crisis.dart';
import 'package:gcma_v1/screens/safe_zones.dart';
import 'package:gcma_v1/screens/damagemap.dart';
import 'package:gcma_v1/services/auth_service.dart';

import 'package:provider/provider.dart';

// ...

class UserHomeScreen extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.red,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _authService.signOut();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey[900],
              ),
              accountName: const Text('User.name'),
              accountEmail: const Text(''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            ListTile(
              minVerticalPadding: 10,
              leading: const Icon(Icons.dashboard, color: Colors.deepPurple),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminPanel()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.group, color: Colors.deepPurple),
              title: const Text('User Management'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserManagement()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning, color: Colors.deepPurple),
              title: const Text('Afet Yönetimi'),
              onTap: () {
                // Afet yönetimi sayfasına yönlendir
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.deepPurple),
              title: const Text('Deprem'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Earthquake()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.water_damage, color: Colors.deepPurple),
              title: const Text('Su Krizi'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WaterCrisis()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.thermostat, color: Colors.deepPurple),
              title: const Text('İklim Krizi'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AirQualityPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.security, color: Colors.deepPurple),
              title: const Text('Güvenli Bölgeler'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AirQualityPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.school, color: Colors.deepPurple),
              title: const Text('Eğitim'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DepremHasarHaritasi()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.blueGrey[100],
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildCardMenuItem(
              context,
              title: 'Earthquake',
              icon: Icons.warning,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Earthquake())),
            ),
            _buildCardMenuItem(
              context,
              title: 'Water Screen',
              icon: Icons.water_damage,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WaterCrisis())),
            ),
            _buildCardMenuItem(
              context,
              title: 'Climate Crisis',
              icon: Icons.wb_cloudy,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AirQualityPage())),
            ),
            _buildCardMenuItem(
              context,
              title: 'Safe Areas',
              icon: Icons.security,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AirQualityPage())),
            ),
            _buildCardMenuItem(
              context,
              title: 'Education',
              icon: Icons.school,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DepremHasarHaritasi())),
            ),
            _buildCardMenuItem(
              context,
              title: 'User Management',
              icon: Icons.group,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserManagement())),
            ),
            _buildCardMenuItem(context,
                title: 'Dashboard',
                icon: Icons.data_usage,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminPanel()))),
          ],
        ),
      ),
    );
  }

  Widget _buildCardMenuItem(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: Colors.blue,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
