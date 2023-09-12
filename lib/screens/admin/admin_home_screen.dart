import 'package:flutter/material.dart';
import 'package:gcma_v1/screens/admin/admin_panel.dart';
import 'package:gcma_v1/screens/user_management.dart';
import 'package:gcma_v1/screens/earthquake.dart';
import 'package:gcma_v1/screens/water_crisis.dart';
import 'package:gcma_v1/screens/climate_crisis.dart';
import 'package:gcma_v1/screens/safe_zones.dart';
import 'package:gcma_v1/screens/damagemap.dart';
import 'package:gcma_v1/services/auth_service.dart';
import 'package:gcma_v1/screens/heatmaps.dart';

import 'package:provider/provider.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        backgroundColor: Colors.brown,
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
              title: 'Heatmap',
              icon: Icons.health_and_safety_outlined,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MapScreen())),
            ),
            _buildCardMenuItem(
              context,
              title: 'Air Quality',
              icon: Icons.cloud,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AirQualityPage())),
            ),
            _buildCardMenuItem(
              context,
              title: 'Damage Map',
              icon: Icons.map,
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
