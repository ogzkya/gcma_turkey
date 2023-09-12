import 'package:flutter/material.dart';
import 'package:gcma_v1/services/dashboard_service.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final DashboardService _dashboardService = DashboardService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blue[900],
      ),
      body: FutureBuilder(
        future: Future.wait([
          _dashboardService.getUserCount(),
          _dashboardService.getRegionCount(),
          _dashboardService.getAppTraffic(),
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('An error occurred'));
          }

          int userCount = snapshot.data![0] as int;
          Map<String, int> regionCount = snapshot.data![1] as Map<String, int>;
          int appTraffic = snapshot.data![2] as int;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildDashboardCard(
                title: 'Registered Users',
                value: userCount,
                icon: Icons.group,
              ),
              _buildRegionCountsCard(
                title: 'User Counts by Region',
                data: regionCount,
                icon: Icons.location_city,
              ),
              _buildDashboardCard(
                title: 'App Traffic',
                value: appTraffic,
                icon: Icons.traffic,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required int value,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 48, color: Colors.deepPurple),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 4),
                Text(value.toString(),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegionCountsCard({
    required String title,
    required Map<String, int> data,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 48, color: Colors.deepPurple),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 4),
                ...data.entries.map((entry) {
                  return Text('${entry.key}: ${entry.value}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple));
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
