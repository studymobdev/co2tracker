import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';

class GoogleMapsPage extends StatefulWidget {
  @override
  State<GoogleMapsPage> createState() => _GoogleMapsPage();
}

class _GoogleMapsPage extends State<GoogleMapsPage> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(49.8186, 73.0931);

  GoogleMapController? _googleMapController;

  LocationData? currentLocation;

  @override
  void dispose() {
    if (_googleMapController != null) {
      _googleMapController!.dispose();
    }
    super.dispose();
  }

  BitmapDescriptor icon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
  }

  final Set<Marker> markers = new Set();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map',
            style: TextStyle(color: Color.fromARGB(238, 248, 240, 227))),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 19, 123, 180),
      ),
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: LatLng(49.8186, 73.0931), zoom: 10.5),
        markers: getmarkers(),
        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },
      ),
    );
  }
//Had to add data recently as iFrame data stopped working
  Set<Marker> getmarkers() {
    setState(() {
      markers.add(Marker(
        markerId: MarkerId(sourceLocation.toString()),
        position: sourceLocation,
        infoWindow: InfoWindow(
          title: 'Home ',
          snippet: 'Maikuduk',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));


    });

    return markers;
  }
}
