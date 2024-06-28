import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController; // Controller for Google map
  LatLng _center = const LatLng(45.521563, -122.677433); // Default location
  Set<Polyline> _polylines = Set<Polyline>(); // For drawing routes

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _loadSafeRoute(); // Load the route when the screen initializes
  }

  void _loadSafeRoute() {
    // This is a sample polyline representing a safe route
    // You would typically fetch this data from a backend or service
    setState(() {
      _polylines.add(
        Polyline(
          polylineId: PolylineId('safe_route_1'),
          visible: true,
          points: [
            LatLng(45.521563, -122.677433),
            LatLng(45.530563, -122.677433),
            LatLng(45.530563, -122.667433),
          ],
          width: 5,
          color: Colors.blue,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safe Route Suggestions'),
        backgroundColor: Colors.blue,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        polylines: _polylines,
      ),
    );
  }
}
