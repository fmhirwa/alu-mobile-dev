import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LatLng _currentPosition = LatLng(0, 0);
  double _todaysDistance = 0.0;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
    _getCurrentLocation();
  }

  Future<void> _fetchUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
      _fetchTodaysDistance();
    }
  }

  Future<void> _fetchTodaysDistance() async {
    if (_userId != null) {
      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('activities')
          .where('userId', isEqualTo: _userId)
          .where('timestamp', isGreaterThan: startOfDay)
          .get();

      double todaysDistance = 0.0;
      for (var doc in snapshot.docs) {
        var activity = doc.data() as Map<String, dynamic>;
        todaysDistance += activity['distance'];
      }

      setState(() {
        _todaysDistance = todaysDistance;
      });
    }
  }

  Future<void> _requestPermissions() async {
  var status = await Permission.location.status;
  if (status.isDenied) {
    await Permission.location.request();
  }
  }
  
  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
    mapController?.animateCamera(
      CameraUpdate.newLatLng(_currentPosition),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Movement'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: RichText(
                text: TextSpan(
                  text: 'Today you walked ',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  children: <TextSpan>[
                    TextSpan(
                        text: '${_todaysDistance.toStringAsFixed(1)} m',
                        style: TextStyle(color: Colors.teal, fontSize: 16)),
                    TextSpan(
                        text: '.',
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 15.0,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('currentLocation'),
                  position: _currentPosition,
                  infoWindow: InfoWindow(title: 'Your Location'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: Icon(Icons.directions_walk, size: 32, color: Colors.blue[800]),
                title: Text('Find Other Walkers'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pushNamed(context, '/walking'); // Navigate to WalkingScreen
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Set this to 1 because this is the map screen
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Summary'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Emergency'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              // Current screen is the map screen
              break;
            case 2:
              Navigator.pushNamed(context, '/emergency');
              break;
          }
        },
      ),
    );
  }
}
