import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchParkData() async {
  final response =
      await http.get(Uri.parse('http://localhost:5000/api/park_data'));

  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load park data');
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};

  static const LatLng _center =
      const LatLng(41.0082, 28.9784); // Istanbul's center coordinates

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _addMarkers(List<Map<String, dynamic>> parkData) {
    parkData.forEach((park) {
      final marker = Marker(
        markerId: MarkerId(park['SIRA NO'].toString()),
        position: LatLng(park['Latitude'], park['Longitude']),
        infoWindow: InfoWindow(
          title: park['MAHAL ADI'],
          snippet: park['TÜR'] + ' - ' + park['İLÇE'],
        ),
      );
      setState(() {
        _markers.add(marker);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchParkData().then((parkData) {
      _addMarkers(parkData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Park ve Yeşil Alanlar'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: _markers,
      ),
    );
  }
}
