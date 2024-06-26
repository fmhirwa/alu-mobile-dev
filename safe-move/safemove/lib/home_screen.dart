import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Example user metrics, you can replace these with actual data sources
  int healthScore = 1536;
  int calories = 500;
  int weight = 58;
  String sleepDuration = 'No Data'; // This could be a time span typically
  int waterIntake = 850;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Good Afternoon'),
        backgroundColor: Colors.blue, // Adjust the color to match your theme
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Text('Health Score: $healthScore Kcal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Calories: $calories Cal Last update 3min',
              style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Weight: $weight Kg Last update 3d',
              style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Sleep duration: $sleepDuration Last update 1min',
              style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Water: $waterIntake ml Last update 3min',
              style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement functionality to log food or update metrics
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Update Metrics'),
                      content: Text('Feature to log or update metrics.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Log Food'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement functionality to add more activities
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Add Activities'),
                      content: Text('Feature to add more activities.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Add Activities'),
            ),
          ],
        ),
      ),
    );
  }
}
