import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Example user metrics, replace these with actual data sources
  final int healthScore = 1536;
  final int calories = 500;
  final int weight = 58;
  final String sleepDuration = 'No Data'; // This could be a time span typically
  final int waterIntake = 850;

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
            _buildMetricCard('Calories', '$calories Cal', 'Last update 3min', Icons.local_fire_department),
            _buildMetricCard('Weight', '$weight Kg', 'Last update 3d', Icons.monitor_weight),
            _buildMetricCard('Water', '$waterIntake ml', 'Last update 3min', Icons.water_drop),
            SizedBox(height: 20),
            Text('Weight Loss', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('-4%', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.red)),
            Text('Last 30 days +2%', style: TextStyle(fontSize: 18, color: Colors.green)),
            SizedBox(height: 10),
            _buildWeightLossGraph(),
            SizedBox(height: 20),
            _buildMetricCard('Sleep Duration', sleepDuration, 'Last update 1min', Icons.bedtime),
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
                Text('$healthScore Kcal', style: TextStyle(fontSize: 16)),
              ],
            ),
            CircularProgressIndicator(
              value: healthScore / 2000, // Example value
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
            leftTitles: AxisTitles(showTitles: false),
            bottomTitles: AxisTitles(showTitles: true, getTitles: (value) {
              switch (value.toInt()) {
                case 0:
                  return '10/1';
                case 1:
                  return '11/1';
                case 2:
                  return '12/1';
                case 3:
                  return '1/1';
                default:
                  return '';
              }
            }),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 1),
                FlSpot(1, 1.5),
                FlSpot(2, 1),
                FlSpot(3, 2),
                FlSpot(4, 1.8),
              ],
              isCurved: true,
              color: [Colors.blue],
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
