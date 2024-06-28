import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class SafetyFeaturesScreen extends StatefulWidget {
  @override
  _SafetyFeaturesScreenState createState() => _SafetyFeaturesScreenState();
}

class _SafetyFeaturesScreenState extends State<SafetyFeaturesScreen> {
  GoogleMapController? _mapController;
  Location _location = Location();
  LatLng _currentPosition = LatLng(-1.9578759, 30.1127352); // Default to a central location

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    var locationData = await _location.getLocation();
    setState(() {
      _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: _currentPosition,
        zoom: 15.0,
      )));
    });
  }

  void _sendPanicAlert() async {
    // Here you would integrate with actual backend or emergency services
    var response = await http.post(
      Uri.parse('https://yourapi/emergency'),
      body: {'latitude': _currentPosition.latitude.toString(), 'longitude': _currentPosition.longitude.toString()}
    );
    if (response.statusCode == 200) {
      // Handle response
      print("Emergency alert sent successfully");
    } else {
      // Error handling
      print("Failed to send alert");
    }
  }

  void _reportIncident() {
    // Implementation for reporting an incident
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Report Incident'),
          content: TextField(
            onSubmitted: (value) {
              // Send incident report to your backend
            },
            decoration: InputDecoration(hintText: "Describe the incident..."),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safety Features'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: CameraPosition(target: _currentPosition, zoom: 14.0),
            markers: Set.from([Marker(markerId: MarkerId('current_loc'), position: _currentPosition)]),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _sendPanicAlert,
              child: Icon(Icons.warning),
              backgroundColor: Colors.red,
            ),
          ),
          Positioned(
            bottom: 80,
            right: 20,
            child: FloatingActionButton(
              onPressed: _reportIncident,
              child: Icon(Icons.report_problem),
              backgroundColor: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
