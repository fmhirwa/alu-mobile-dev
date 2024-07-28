import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _userId;
  double _dailyGoal = 0.0;
  double _totalDistance = 0.0;
  String? _profileImageUrl;
  List<Map<String, dynamic>> _recentActivities = [];
  List<FlSpot> _weeklyData = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
      DocumentSnapshot userProfile =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userProfile.exists) {
        setState(() {
          _dailyGoal = (userProfile['goal'] ?? 0.0).toDouble();
          _profileImageUrl = userProfile['profileImageUrl'] ?? 'lib/assets/profile_image.png';
        });
        _fetchUserActivities();
      }
    }
  }

  Future<void> _fetchUserActivities() async {
    if (_userId != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('activities')
          .where('userId', isEqualTo: _userId)
          .orderBy('timestamp', descending: true)
          .limit(7)
          .get();

      double totalDistance = 0.0;
      List<FlSpot> weeklyData = [];
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

      for (var doc in snapshot.docs) {
        var activity = doc.data() as Map<String, dynamic>;
        totalDistance += activity['distance'];
        DateTime date = (activity['timestamp'] as Timestamp).toDate();
        if (date.isAfter(startOfWeek)) {
          weeklyData.add(FlSpot(date.weekday.toDouble(), activity['distance'].toDouble()));
        }
      }

      setState(() {
        _recentActivities = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        _totalDistance = totalDistance;
        _weeklyData = weeklyData;
      });
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Navigator.pushNamed(context, '/home');
          break;
        case 1:
          Navigator.pushNamed(context, '/map');
          break;
        case 2:
          Navigator.pushNamed(context, '/emergency');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double percentageOfGoal = _dailyGoal > 0 ? (_totalDistance / _dailyGoal) : 0;
    DateTime now = DateTime.now();
    String currentDate = DateFormat('EEEE, d MMM').format(now);

    return Scaffold(
      appBar: AppBar(
        title: Text('SafeMove'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: CircleAvatar(
              backgroundImage: _profileImageUrl != null
                  ? NetworkImage(_profileImageUrl!)
                  : AssetImage('lib/assets/profile_image.png') as ImageProvider,
              radius: 20,
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(currentDate, style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 20),
            _buildHealthScoreCard(percentageOfGoal),
            SizedBox(height: 20),
            Text('Total this week: ${_totalDistance.toStringAsFixed(1)} m', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            Text('Recent Activities', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildRecentActivities(),
            SizedBox(height: 30),
            Text('Weekly Distance', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildDistanceChart(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Summary'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Emergency'),
        ],
      ),
    );
  }

  Widget _buildHealthScoreCard(double percentageOfGoal) {
    return Card(
      color: Colors.teal[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Goal Achievement', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('${(percentageOfGoal * 100).toStringAsFixed(1)}%', style: TextStyle(fontSize: 16)),
              ],
            ),
            CircularProgressIndicator(
              value: percentageOfGoal,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00ACC1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      children: _recentActivities.map((activity) {
        DateTime date = (activity['timestamp'] as Timestamp).toDate();
        return ListTile(
          title: Text('${activity['distance']} m'),
          subtitle: Text(DateFormat('d MMM y HH:mm').format(date)),
        );
      }).toList(),
    );
  }

  Widget _buildDistanceChart() {
    return Container(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 1:
                      return Text('Mon');
                    case 2:
                      return Text('Tue');
                    case 3:
                      return Text('Wed');
                    case 4:
                      return Text('Thu');
                    case 5:
                      return Text('Fri');
                    case 6:
                      return Text('Sat');
                    case 7:
                      return Text('Sun');
                    default:
                      return Text('');
                  }
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d)),
          ),
          minX: 1,
          maxX: 7,
          minY: 0,
          lineBarsData: [
            LineChartBarData(
              spots: _weeklyData,
              isCurved: true,
              color: Color(0xFF2196F3),
              barWidth: 6,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(
                show: true,
                color: Color(0xFF2196F3).withOpacity(0.3),
              ),
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
