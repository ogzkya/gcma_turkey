import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EarthquakeService {
  // Verileri ne sıklıkla güncellemek istediğinize karar verin (örneğin: 1 dakika = Duration(minutes: 1))
  Duration updateInterval = const Duration(minutes: 1);

  Stream<List<Map<String, dynamic>>?> fetchEarthquakeData() async* {
    while (true) {
      try {
        final response = await http.get(Uri.parse(
            'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson'));

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          final earthquakeList =
              jsonData['features'].map<Map<String, dynamic>>((earthquake) {
            return {
              'title': earthquake['properties']['title'],
              'magnitude': earthquake['properties']['mag'],
              'time': earthquake['properties']['time'],
              'latitude': earthquake['geometry']['coordinates'][1],
              'longitude': earthquake['geometry']['coordinates'][0],
              'depth': earthquake['geometry']['coordinates'][2],
              'place': earthquake['properties']['place'],
              'felt': earthquake['properties']['felt'],
              'tsunami': earthquake['properties']['tsunami'],
              'type': earthquake['properties']['type'],
              'status': earthquake['properties']['status'],
            };
          }).toList();
        } else {
          throw Exception('Failed to load earthquake data');
        }
      } catch (e) {
        print('Error fetching earthquake data: $e');
      }
      await Future.delayed(updateInterval);
    }
  }
}
