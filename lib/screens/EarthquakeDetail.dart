import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class EarthquakeDetail extends StatefulWidget {
  final Map<String, dynamic> earthquake;

  EarthquakeDetail({required this.earthquake});

  @override
  _EarthquakeDetailState createState() => _EarthquakeDetailState();
}

class _EarthquakeDetailState extends State<EarthquakeDetail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildInfoCard(String label, String value,
      {required Color bgColor, required Color textColor}) {
    return Card(
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500, color: textColor),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final earthquake = widget.earthquake;
    final time =
        DateTime.fromMillisecondsSinceEpoch(earthquake['time']).toLocal();
    final formattedTime = DateFormat('dd-MM-yyyy HH:mm:ss').format(time);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Earthquake Details'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              earthquake['title'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildInfoCard('Magnitude', '${earthquake['magnitude']}',
                    bgColor: Colors.orange.shade300, textColor: Colors.white),
                _buildInfoCard('Time', formattedTime,
                    bgColor: Colors.blue.shade300, textColor: Colors.white),
                _buildInfoCard('Latitude', '${earthquake['latitude']}',
                    bgColor: Colors.green.shade300, textColor: Colors.white),
                _buildInfoCard('Longitude', '${earthquake['longitude']}',
                    bgColor: Colors.purple.shade300, textColor: Colors.white),
                _buildInfoCard('Depth', '${earthquake['depth']} km',
                    bgColor: Colors.red.shade300, textColor: Colors.white),
                _buildInfoCard(
                    'Felt', '${earthquake['felt'] == 0 ? 'yes' : 'no'}',
                    bgColor: Colors.teal.shade300, textColor: Colors.white),
                _buildInfoCard(
                    'Tsunami', earthquake['tsunami'] == 1 ? 'Yes' : 'No',
                    bgColor: Colors.indigo.shade300, textColor: Colors.white),
                _buildInfoCard('Status', '${earthquake['status']}',
                    bgColor: Colors.deepOrange.shade300,
                    textColor: Colors.white),
              ],

              // 31.03.2023 RMK tarafından eklendi
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Earthquake Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              width: double.infinity,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target:
                      LatLng(earthquake['latitude'], earthquake['longitude']),
                  zoom: 8,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(earthquake['title']),
                    position:
                        LatLng(earthquake['latitude'], earthquake['longitude']),
                  ),
                },
                mapType: MapType.hybrid,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'More Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () {
                // TODO: Implement navigation to a more detailed information page or external source
              },
              child: const Text(
                'Click here for more details about this earthquake',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Safety Tips',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Drop, cover, and hold on. Stay indoors until the shaking stops and it is safe to go outside.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              '2. Stay away from glass, windows, outside doors, and walls. Move to the center of the room.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              '3. If you are outdoors, stay away from buildings, streetlights, and utility wires.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              '4. If you are in a vehicle, stop as quickly as possible and stay in the vehicle. Avoid stopping near or under buildings, trees, overpasses, and utility wires.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              '5. Be prepared for aftershocks, which are smaller earthquakes that follow the main shock.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
