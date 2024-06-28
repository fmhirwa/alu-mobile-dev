import 'package:flutter/material.dart';
import 'package:safemove/map_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
//import 'home_new.dart';
import 'profile_screen.dart';
//import 'map_screen.dart';
import 'report.dart';
import 'walking_screen.dart';

void main() {
  runApp(SafeMoveApp());
}

class SafeMoveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeMove',
      theme: ThemeData(
        primaryColor: Colors.cyan[600],
        hintColor: Colors.cyan[600],
        fontFamily: 'Arial',
        /*
        textTheme: Theme.of(context).textTheme.copyWith(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),*/
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => UserProfileScreen(),
        '/map': (context) => MapScreen(),            
        '/emergency': (context) => ReportScreen(),  
        '/walking': (context) => WalkingScreen(),
        
      },
      onGenerateRoute: (settings) {
        // Handle undefined routes
        return MaterialPageRoute(builder: (context) => UndefinedScreen());
      },
    );
  }
}

class UndefinedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route Not Found'),
      ),
      body: Center(
        child: Text('404: The page you are looking for is not available.'),
      ),
    );
  }
}

