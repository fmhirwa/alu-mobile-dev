import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'profile_screen.dart';
import 'map_screen.dart';
import 'report.dart';
//import 'package:fl_chart/fl_chart.dart';
//import 'lib/Assets/profile_image.png';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => UserProfileScreen(),
        '/map': (context) => MapScreen(),
        '/emergency': (context) => ReportScreen(),
      },
    );
  }
}

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Good Afternoon 🌤️'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: CircleAvatar(
              backgroundImage: AssetImage('lib/assets/profile_image.png'),
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
            Text('Saturday 17 Feb', style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 20),
            _buildHealthScoreCard(),
            SizedBox(height: 30),
            Text('Metrics', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildMetricCard('Calories', '$calories Cal', 'Last update 3min', 'assets/calories.svg'),
            _buildMetricCard('Weight', '$weight Kg', 'Last update 3d', 'assets/weight.svg'),
            _buildMetricCard('Water', '$waterIntake ml', 'Last update 3min', 'assets/water.svg'),
            SizedBox(height: 20),
            Text('Weight Loss', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('-4%', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.red)),
            Text('Last 30 days +2%', style: TextStyle(fontSize: 18, color: Colors.cyan[600])),
            SizedBox(height: 10),
            _buildWeightLossGraph(),
            SizedBox(height: 20),
            _buildMetricCard('Sleep Duration', sleepDuration, 'Last update 1min', 'assets/sleep.svg'),
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
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00ACC1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String updateInfo, String assetPath) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        //leading: SvgPicture.asset(assetPath, width: 42, height: 42),
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
      child: Placeholder(), // Replace with actual graph implementation
    );
  }
}
