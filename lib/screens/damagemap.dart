import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:gcma_v1/data/kucukcekmece.dart';

class DepremHasarHaritasi extends StatefulWidget {
  @override
  _DepremHasarHaritasiState createState() => _DepremHasarHaritasiState();
}

class _DepremHasarHaritasiState extends State<DepremHasarHaritasi> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};

  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;

  Future<void> loadCustomIcon() async {
    final ByteData customIconData =
        await rootBundle.load('assets/images/building.png');
    final Uint8List bytes = customIconData.buffer.asUint8List();
    final BitmapDescriptor customIcon = BitmapDescriptor.fromBytes(bytes);

    setState(() {
      this.customIcon = customIcon;
    });
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    addMarkers();
  }

  void addMarkers() {
    for (var mahalle in mahalleler) {
      setState(() {
        markers.add(
          Marker(
            icon: customIcon,
            markerId: MarkerId(mahalle.ad),
            position: LatLng(mahalle.lat, mahalle.lng),
            infoWindow: InfoWindow(
              title: mahalle.ad,
              onTap: () {
                showMahalleDetails(context, mahalle);
              },
            ),
          ),
        );
      });
    }
  }

  void showMahalleDetails(BuildContext context, Mahalle mahalle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(16.0),
          titlePadding: EdgeInsets.all(12.0),
          contentPadding: EdgeInsets.all(12.0),
          title: Text(
            '${mahalle.ad} Damage Status',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.4,
              child: HasarVeriListesi(mahalle: mahalle),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Close',
                style: TextStyle(fontSize: 18, color: Colors.blueGrey),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loadCustomIcon(); // Özel ikonu yükle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Earthquake Damage Map'),
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            icon: Icon(Icons.zoom_in),
            onPressed: () {
              mapController.animateCamera(CameraUpdate.zoomIn());
            },
          ),
          IconButton(
            icon: Icon(Icons.zoom_out),
            onPressed: () {
              mapController.animateCamera(CameraUpdate.zoomOut());
            },
          )
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(41.005132, 28.788354), // İstanbul'un koordinatları
              zoom: 10,
            ),
            markers: markers,
            myLocationEnabled: false,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: false,
            myLocationButtonEnabled: false,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 175,
                child: ListView.builder(
                  itemCount: ilceler.length,
                  itemBuilder: (BuildContext context, int index) {
                    Ilce ilce = ilceler[index];
                    return ExpansionTile(
                      title: Text(
                        ilce.ad,
                        style: TextStyle(color: Colors.blueGrey.shade800),
                      ),
                      children: ilce.mahalleler.map((mahalle) {
                        return Card(
                          color: Colors.blueGrey[50],
                          child: ListTile(
                            title: Text(
                              mahalle.ad,
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                            onTap: () {
                              showMahalleDetails(context, mahalle);
                            },
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HasarVeriListesi extends StatelessWidget {
  final Mahalle mahalle;

  HasarVeriListesi({required this.mahalle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text('Heavily damaged'),
          trailing: SizedBox(
            width: 150,
            child: Stack(
              children: [
                LinearProgressIndicator(
                  value: mahalle.cokAgirHasarli / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
                Center(
                  child: Text(
                    '${mahalle.cokAgirHasarli}',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
        ListTile(
          title: Text('Severely damaged'),
          trailing: SizedBox(
            width: 150,
            child: Stack(
              children: [
                LinearProgressIndicator(
                  value: mahalle.agirHasarli / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
                Center(
                  child: Text(
                    '${mahalle.agirHasarli}',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
        ListTile(
          title: Text('Moderately damaged'),
          trailing: SizedBox(
            width: 150,
            child: Stack(
              children: [
                LinearProgressIndicator(
                  value: mahalle.ortaHasarli / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                ),
                Center(
                  child: Text(
                    '${mahalle.ortaHasarli}',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
        ListTile(
          title: Text('Slightly damaged'),
          trailing: SizedBox(
            width: 150,
            child: Stack(
              children: [
                LinearProgressIndicator(
                  value: mahalle.hafifHasarli / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                Center(
                  child: Text(
                    '${mahalle.hafifHasarli}',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
