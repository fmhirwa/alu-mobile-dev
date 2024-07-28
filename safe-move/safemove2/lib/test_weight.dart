import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _userId;
  int _healthScore = 0;
  int _calories = 0;
  int _weight = 0;
  String _sleepDuration = 'No Data';
  int _waterIntake = 0;
  List<FlSpot> _weightData = [];

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
          _healthScore = userProfile['healthScore'] ?? 0;
          _calories = userProfile['calories'] ?? 0;
          _weight = userProfile['weight'] ?? 0;
          _sleepDuration = userProfile['sleepDuration'] ?? 'No Data';
          _waterIntake = userProfile['waterIntake'] ?? 0;
        });
        _fetchWeightData();
      }
    }
  }

  Future<void> _fetchWeightData() async {
    if (_userId != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('weightData')
          .where('userId', isEqualTo: _userId)
          .orderBy('timestamp', descending: true)
          .get();
      List<FlSpot> weightData = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return FlSpot((data['timestamp'] as Timestamp).toDate().millisecondsSinceEpoch.toDouble(), data['weight'].toDouble());
      }).toList();
      setState(() {
        _weightData = weightData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Good Afternoon 🌤️'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/profile_image.png'),
            radius: 20,
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Saturday 17 Feb', style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 20),
            _buildHealthScoreCard(),
            SizedBox(height: 30),
            Text('Metrics', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildMetricCard('Calories', '$_calories Cal', 'Last update 3min', Icons.local_fire_department),
            _buildMetricCard('Weight', '$_weight Kg', 'Last update 3d', Icons.monitor_weight),
            _buildMetricCard('Water', '$_waterIntake ml', 'Last update 3min', Icons.water_drop),
            SizedBox(height: 20),
            Text('Weight Loss', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('-4%', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.red)),
            Text('Last 30 days +2%', style: TextStyle(fontSize: 18, color: Colors.green)),
            SizedBox(height: 10),
            _buildWeightLossGraph(),
            SizedBox(height: 20),
            _buildMetricCard('Sleep Duration', _sleepDuration, 'Last update 1min', Icons.bedtime),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Update this index as needed
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Summary'),
          BottomNavigationBarItem(icon: Icon(Icons.share), label: 'Sharing'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Browse'),
        ],
        onTap: (index) {
          // Handle navigation based on the index
        },
      ),
    );
  }

  Widget _buildHealthScoreCard() {
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
                Text('Health Score', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('$_healthScore Kcal', style: TextStyle(fontSize: 16)),
              ],
            ),
            CircularProgressIndicator(
              value: _healthScore / 2000, // Example value
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String updateInfo, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, size: 42, color: Colors.blue[800]),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$value • $updateInfo'),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          // Handle tap
        },
      ),
    );
  }

  Widget _buildWeightLossGraph() {
    return Container(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  var date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('${date.day}/${date.month}'),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: _weightData,
              isCurved: true,
              backgroundColor: Colors.blue,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
