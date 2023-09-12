import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AirQualityStation {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  AirQualityStation({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory AirQualityStation.fromJson(Map<String, dynamic> json) {
    String locationString = json['Location'] as String;
    List<String> locationCoords = locationString
        .substring(locationString.indexOf('(') + 1, locationString.indexOf(')'))
        .split(' ');

    return AirQualityStation(
      id: json['Id'] as String,
      name: json['Name'] as String,
      address: json['Adress'] as String,
      latitude: double.parse(locationCoords[1]),
      longitude: double.parse(locationCoords[0]),
    );
  }
}

Future<List<AirQualityStation>> _fetchAirQualityStations() async {
  final response = await http.get(Uri.parse(
      'https://api.ibb.gov.tr/havakalitesi/OpenDataPortalHandler/GetAQIStations'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
    return jsonResponse
        .map((airQualityStation) =>
            AirQualityStation.fromJson(airQualityStation))
        .toList();
  } else {
    throw Exception('Failed to load air quality stations');
  }
}

class AirQualityPage extends StatefulWidget {
  @override
  _AirQualityPageState createState() => _AirQualityPageState();
}

class _AirQualityPageState extends State<AirQualityPage> {
  late Future<List<AirQualityStation>> _aqiStationsFuture;

  @override
  void initState() {
    super.initState();
    _aqiStationsFuture = _fetchAirQualityStations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Air Qual1ity'),
        backgroundColor: Colors.blue[900],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _aqiStationsFuture = _fetchAirQualityStations();
          });
        },
        child: FutureBuilder<List<AirQualityStation>>(
          future: _aqiStationsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(child: Text('Veri bulunamadı'));
              }
              return _buildCardList(snapshot.data!);
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Hata: ${snapshot.error}'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _aqiStationsFuture = _fetchAirQualityStations();
                        });
                      },
                      child: Text('Yeniden dene'),
                    ),
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildCardList(List<AirQualityStation> aqiStations) {
    return ListView.builder(
      itemCount: aqiStations.length,
      itemBuilder: (context, index) {
        final station = aqiStations[index];
        return AirQualityStationCard(station: station);
      },
    );
  }
}

class AirQualityStationCard extends StatelessWidget {
  final AirQualityStation station;

  AirQualityStationCard({required this.station});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              station.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Address: ${station.address}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 16),
            AqiProgressIndicator(aqi: station.name.length),
          ],
        ),
      ),
    );
  }
}

class AqiProgressIndicator extends StatelessWidget {
  final int aqi;

  AqiProgressIndicator({required this.aqi});

  Color _getAqiColor(int aqi) {
    if (aqi <= 50) {
      return Colors.green;
    } else if (aqi > 50 && aqi <= 100) {
      return Colors.yellow;
    } else if (aqi > 100 && aqi <= 150) {
      return Colors.orange;
    } else if (aqi > 150 && aqi <= 200) {
      return Colors.red;
    } else if (aqi > 200 && aqi <= 300) {
      return Colors.purple;
    } else {
      return Colors.brown;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 10,
            child: LinearProgressIndicator(
              value: aqi / 25,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(_getAqiColor(aqi)),
            ),
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'AiQ: $aqi',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              _getAqiLabel(aqi),
              style: TextStyle(fontSize: 14, color: _getAqiColor(aqi)),
            ),
          ],
        ),
      ],
    );
  }

  String _getAqiLabel(int aqi) {
    if (aqi <= 50) {
      return 'Good';
    } else if (aqi > 50 && aqi <= 100) {
      return 'Moderate';
    } else if (aqi > 100 && aqi <= 150) {
      return 'Unhealthy for Sensitive Groups';
    } else if (aqi > 150 && aqi <= 200) {
      return 'Unhealthy';
    } else if (aqi > 200 && aqi <= 300) {
      return 'Very Unhealthy';
    } else {
      return 'Hazardous';
    }
  }
}
