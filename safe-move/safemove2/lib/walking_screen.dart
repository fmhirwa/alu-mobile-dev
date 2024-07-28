import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class WalkingScreen extends StatefulWidget {
  @override
  _WalkingScreenState createState() => _WalkingScreenState();
}

class _WalkingScreenState extends State<WalkingScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _distanceController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  String? _userId;
  List<Map<String, dynamic>> _activities = [];
  double _totalWeek = 0.0;
  double _totalMonth = 0.0;
  GoogleMapController? _mapController;
  LatLng _currentPosition = LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _fetchUserId();
    _fetchActivities();
    _getCurrentLocation();
  }

  Future<void> _fetchUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
      _fetchActivities();
    }
  }

  Future<void> _fetchActivities() async {
    if (_userId != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('activities')
          .where('userId', isEqualTo: _userId)
          .get();
      List<Map<String, dynamic>> activities = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      setState(() {
        _activities = activities;
        _calculateTotals();
      });
    }
  }

  void _calculateTotals() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime startOfMonth = DateTime(now.year, now.month, 1);

    double totalWeek = 0.0;
    double totalMonth = 0.0;

    for (var activity in _activities) {
      DateTime activityDate = (activity['timestamp'] as Timestamp).toDate();
      double distance = activity['distance'].toDouble();
      if (activityDate.isAfter(startOfWeek)) {
        totalWeek += distance;
      }
      if (activityDate.isAfter(startOfMonth)) {
        totalMonth += distance;
      }
    }

    setState(() {
      _totalWeek = totalWeek;
      _totalMonth = totalMonth;
    });
  }

  Future<void> _logActivity() async {
    if (_formKey.currentState!.validate()) {
      if (_userId != null) {
        await FirebaseFirestore.instance.collection('activities').add({
          'userId': _userId,
          'distance': double.parse(_distanceController.text),
          'duration': int.parse(_durationController.text),
          'timestamp': Timestamp.now(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Activity logged successfully')),
        );
        _distanceController.clear();
        _durationController.clear();
        _fetchActivities(); // Fetch activities again to update the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in')),
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(_currentPosition),
    );
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
        title: Text('Walking'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: 'This week you walked ',
                style: TextStyle(color: Colors.black, fontSize: 16),
                children: <TextSpan>[
                  TextSpan(
                      text: '${_totalWeek.toStringAsFixed(1)} m',
                      style: TextStyle(color: Colors.blue, fontSize: 16)),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text('Total this week: ${_totalWeek.toStringAsFixed(1)} m'),
            Text('Total this month: ${_totalMonth.toStringAsFixed(1)} m'),
            SizedBox(height: 20),
            Container(
              height: 200,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                  _getCurrentLocation();
                },
                initialCameraPosition: CameraPosition(
                  target: _currentPosition,
                  zoom: 15,
                ),
                myLocationEnabled: true,
              ),
            ),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _activities.length,
              itemBuilder: (context, index) {
                var activity = _activities[index];
                return ListTile(
                  title: Text('${activity['distance']} m'),
                  subtitle: Text(
                      '${(activity['timestamp'] as Timestamp).toDate()}'),
                );
              },
            ),
            SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _distanceController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Distance (m)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the distance';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _durationController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Duration (minutes)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the duration';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _logActivity,
                    child: Text('Log Activity'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      minimumSize: Size(double.infinity, 50), // Set the width and height of the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Set this to 1 because this is the Sharing screen
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Summary'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_walk), label: 'Sharing'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Browse'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              // Current screen is the walking screen
              break;
            case 2:
              Navigator.pushNamed(context, '/browse');
              break;
          }
        },
      ),
    );
  }

  Widget _buildStatusCard(String status, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
