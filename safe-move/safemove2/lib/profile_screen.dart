import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Handle settings button press
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('lib/assets/profile_image.png'), 
              radius: 50,
            ),
            SizedBox(height: 10),
            Text("Lupita Nyong'o", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text('@lupita', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
            SizedBox(height: 20),
            _buildProfileItem(Icons.person, 'Female, 27 years old'),
            _buildProfileItem(Icons.location_on, 'Kigali, Rwanda'),
            _buildProfileItem(Icons.lock, 'Privacy Shortcuts'),
            _buildProfileItem(Icons.help, 'Help Center'),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Handle log out button press
              },
              child: Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF5252),
                minimumSize: Size(double.infinity, 50), // Set the width and height of the button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Update this index as needed
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Summary'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Emmergency'),
        ],
        onTap: (index) {
          // Handle navigation based on the index
        },
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String text) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, size: 32, color: Colors.blue[800]),
        title: Text(text, style: TextStyle(fontSize: 18)),
        onTap: () {
          // Handle item tap if needed
        },
      ),
    );
  }
}
