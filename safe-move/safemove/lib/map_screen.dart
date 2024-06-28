import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class SafeRouteScreen extends StatefulWidget {
  @override
  _SafeRouteScreenState createState() => _SafeRouteScreenState();
}

class _SafeRouteScreenState extends State<SafeRouteScreen> {
  GoogleMapController? _controller;
  Location _location = Location();
  LatLng _currentPosition = LatLng(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    _location.onLocationChanged.listen((LocationData currentLocation) {
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0,
            target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
            zoom: 17.0,
          ),
        ),
      );
      setState(() {
        _currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safe Routes'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 14.0,
        ),
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _createMarkers(),
        polylines: _createRoutes(),
      ),
    );
  }

  Set<Marker> _createMarkers() {
    return {
      Marker(
        markerId: MarkerId("current_location"),
        position: _currentPosition,
        infoWindow: InfoWindow(title: "Your Location"),
      ),
    };
  }

  Set<Polyline> _createRoutes() {
    // Example route, replace with actual route data
    List<LatLng> routePoints = [
      LatLng(_currentPosition.latitude, _currentPosition.longitude),
      LatLng(_currentPosition.latitude + 0.01, _currentPosition.longitude + 0.01), // example endpoint
    ];
    return {
      Polyline(
        polylineId: PolylineId('safe_route_1'),
        points: routePoints,
        width: 5,
        color: Colors.blue,
      ),
    };
  }
}
