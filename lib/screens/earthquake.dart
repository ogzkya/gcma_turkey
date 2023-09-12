import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:gcma_v1/screens/EarthquakeDetail.dart';

class Earthquake extends StatefulWidget {
  @override
  _EarthquakeState createState() => _EarthquakeState();
}

class _EarthquakeState extends State<Earthquake> {
  List<Map<String, dynamic>> _earthquakeData = [];
  Set<Marker> _markers = {};
  double _minMagnitude = 2.5;

  @override
  void initState() {
    super.initState();
    _fetchEarthquakeData();
  }

  Future<void> _fetchEarthquakeData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson'));
      final data = json.decode(response.body);
      final features = data['features'];

      if (response.statusCode == 200) {
        setState(() {
          _earthquakeData = features.map<Map<String, dynamic>>((feature) {
            final coords = feature['geometry']['coordinates'];
            final properties = feature['properties'];

            return {
              'latitude': coords[1],
              'longitude': coords[0],
              'title': properties['title'],
              'magnitude': properties['mag'],
              'time': properties['time'],
              'depth': coords[2],
              'place': properties['place'],
              'felt': properties['felt'],
              'tsunami': properties['tsunami'],
              'type': properties['type'],
              'status': properties['status'],
            };
          }).toList();

          _markers = _earthquakeData.map<Marker>((earthquake) {
            return Marker(
              markerId: MarkerId(earthquake['title']),
              position: LatLng(earthquake['latitude'], earthquake['longitude']),
              infoWindow: InfoWindow(
                title: earthquake['title'],
                snippet: 'Magnitude: ${earthquake['magnitude']}',
              ),
            );
          }).toSet();
        });
      } else {
        throw Exception('Failed to load earthquake data');
      }
    } catch (e) {
      print('Failed to load earthquake data: $e');
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Earthquakes'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Set minimum magnitude:'),
                Slider(
                  value: _minMagnitude,
                  min: 0,
                  max: 10,
                  divisions: 20,
                  onChanged: (value) {
                    setState(() {
                      _minMagnitude = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Apply'),
              onPressed: () {
                Navigator.of(context).pop();
                _fetchEarthquakeData();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDepremCard(Map<String, dynamic> earthquake) {
    final time =
        DateTime.fromMillisecondsSinceEpoch(earthquake['time']).toLocal();
    final formattedTime = DateFormat('dd-MM-yyyy HH:mm:ss').format(time);

    Color _getMagnitudeColor(double magnitude) {
      if (magnitude >= 7.0) {
        return Colors.red;
      } else if (magnitude >= 5.0) {
        return Colors.orange;
      } else {
        return Colors.green;
      }
    }

    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EarthquakeDetail(earthquake: earthquake),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: _getMagnitudeColor(
                          earthquake["magnitude"].toDouble()),
                    ),
                    child: Center(
                      child: Text(
                        earthquake['magnitude'].toString(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      earthquake['title'],
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Time: $formattedTime',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Earthquake'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            'Earthquake Information',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Information, data, statistics and important warnings about the earthquake will come here.',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Container(
            height: 300,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(38.9637, 35.2433),
                zoom: 5,
              ),
              markers: _markers,
              mapType: MapType.hybrid,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Last Earthquakes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _earthquakeData.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildDepremCard(_earthquakeData[index]);
            },
          ),
        ],
      ),
    );
  }
}
