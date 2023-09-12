import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WaterCrisis extends StatefulWidget {
  WaterCrisis({Key? key}) : super(key: key);

  @override
  _WaterCrisisState createState() => _WaterCrisisState();
}

class _WaterCrisisState extends State<WaterCrisis> {
  late Future<List<WaterData>> futureWaterData;

  @override
  void initState() {
    super.initState();
    futureWaterData = fetchWaterData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Level Data'),
        backgroundColor: Colors.blue[400],
      ),
      body: FutureBuilder<List<WaterData>>(
        future: futureWaterData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                    elevation: 5,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: FittedBox(
                            child: Text('${snapshot.data![index].waterLevel}%'),
                          ),
                        ),
                      ),
                      title: Text(snapshot.data![index].name,
                          style: Theme.of(context).textTheme.headline6),
                      subtitle: Text('Risk: ${snapshot.data![index].risk}',
                          style: Theme.of(context).textTheme.subtitle1),
                      trailing: IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  WaterDetail(waterData: snapshot.data![index]),
                            ),
                          );
                        },
                      ),
                    ));
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Something went wrong...'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('Try Again'),
                    onPressed: () {
                      // Retry function here
                    },
                  ),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class WaterData {
  final String markerId;
  final String name;
  final LatLng location;
  final int waterLevel;
  final String risk;

  WaterData(
      {required this.markerId,
      required this.name,
      required this.location,
      required this.waterLevel,
      required this.risk});

  factory WaterData.fromJson(Map<String, dynamic> json, String id) {
    return WaterData(
      markerId: id,
      name: json['name'],
      location:
          LatLng(json['location']['latitude'], json['location']['longitude']),
      waterLevel: json['waterLevel'],
      risk: json['risk'],
    );
  }
}

Future<List<WaterData>> fetchWaterData() async {
  String jsonString = await rootBundle.loadString('assets/water_data.json');
  Map<String, dynamic> jsonResponse =
      jsonDecode(jsonString); // Veriyi önce bir Map olarak oku

  List<dynamic> dataList =
      jsonResponse['data']; // 'data' anahtarını kullanarak listeni al

  return dataList
      .map((item) => WaterData.fromJson(item, item['id'].toString()))
      .toList();
}

class WaterDetail extends StatelessWidget {
  final WaterData waterData;
  final Completer<GoogleMapController> _controller = Completer();

  WaterDetail({required this.waterData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail for ${waterData.name}'),
        backgroundColor: Colors.blue[400],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              waterData.name,
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 20),
            Text(
              'Water Level: ${waterData.waterLevel}%',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 10),
            Text(
              'Risk: ${waterData.risk}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 10),
            Text(
              'Location: Latitude - ${waterData.location.latitude}, Longitude - ${waterData.location.longitude}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 10),
            Container(
              height: 250,
              child: GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    waterData.location.latitude,
                    waterData.location.longitude,
                  ),
                  zoom: 14,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: {
                  Marker(
                    markerId: MarkerId(waterData.markerId),
                    position: LatLng(
                      waterData.location.latitude,
                      waterData.location.longitude,
                    ),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
