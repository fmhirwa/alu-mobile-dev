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
import 'welcome.dart';
import 'auth_state_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/*
void main() {
  runApp(SafeMoveApp());
  Firebase.initializeApp();
}
*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(SafeMoveApp());
}

/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SafeMoveApp());
}*/

class SafeMoveApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeMove',
      theme: ThemeData(
        primaryColor: Colors.cyan[600],
        hintColor: Colors.cyan[600],
        fontFamily: 'Roboto',
        textTheme: Theme.of(context).textTheme.copyWith(
              displayLarge:
                  TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              displayMedium:
                  TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
              displaySmall: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            ),
      ),
      //initialRoute: '/',
      home: WelcomeScreen(),
      //AuthStateHandler(),
      routes: {
        '/login': (context) => LoginScreen(),
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

/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SafeMoveApp());
}*/

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
