import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _goalController = TextEditingController();
  String _gender = 'Female';
  int _age = 27;
  String? _userId;
  String? _profileImageUrl;
  bool _isEditing = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
      DocumentSnapshot userProfile = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userProfile.exists) {
        setState(() {
          _nameController.text = userProfile['name'] ?? '';
          _usernameController.text = userProfile['username'] ?? '';
          _locationController.text = userProfile['location'] ?? '';
          _gender = userProfile['gender'] ?? 'Female';
          _age = userProfile['age'] ?? 27;
          _weightController.text = userProfile['weight']?.toString() ?? '';
          _goalController.text = userProfile['goal']?.toString() ?? '';
          _profileImageUrl = userProfile['profileImageUrl'] ?? '';
        });
      }
    }
  }

  Future<void> _updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      if (_userId != null) {
        await FirebaseFirestore.instance.collection('users').doc(_userId).update({
          'name': _nameController.text,
          'username': _usernameController.text,
          'location': _locationController.text,
          'gender': _gender,
          'age': _age,
          'weight': double.tryParse(_weightController.text),
          'goal': double.tryParse(_goalController.text),
          'profileImageUrl': _profileImageUrl,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String fileName = 'profile_images/${_userId}_${DateTime.now().millisecondsSinceEpoch}';
      try {
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child(fileName);
        await ref.putFile(imageFile);
        String downloadUrl = await ref.getDownloadURL();
        setState(() {
          _profileImageUrl = downloadUrl;
        });
        _updateUserProfile();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    }
  }

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
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _isEditing ? _pickImage : null,
                child: CircleAvatar(
                  backgroundImage: _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                      ? NetworkImage(_profileImageUrl!)
                      : AssetImage('lib/assets/profile_image.png') as ImageProvider,
                  radius: 50,
                ),
              ),
              SizedBox(height: 10),
              _buildTextField(_nameController, "Name", enabled: _isEditing),
              SizedBox(height: 10),
              _buildTextField(_usernameController, "Username", enabled: _isEditing),
              SizedBox(height: 10),
              _buildTextField(_locationController, "Location", enabled: _isEditing),
              SizedBox(height: 10),
              _buildDropdownButtonFormField("Gender", enabled: _isEditing),
              SizedBox(height: 10),
              _buildTextField(
                TextEditingController(text: _age.toString()),
                "Age",
                enabled: _isEditing,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _age = int.tryParse(value) ?? _age;
                  });
                },
              ),
              SizedBox(height: 10),
              _buildTextField(_weightController, "Weight (kg)", enabled: _isEditing),
              SizedBox(height: 10),
              _buildTextField(_goalController, "Daily Distance Goal (m)", enabled: _isEditing),
              SizedBox(height: 20),
              if (_isEditing)
                ElevatedButton(
                  onPressed: _updateUserProfile,
                  child: Text('Update Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: Size(double.infinity, 50), // Set the width and height of the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Handle log out button press
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Update this index as needed
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Summary'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Emergency'),
        ],
        onTap: (index) {
          // Handle navigation based on the index
          switch (index) {
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
        },
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText, {
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      enabled: enabled,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $labelText';
        }
        if (keyboardType == TextInputType.number && double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownButtonFormField(String labelText, {bool enabled = true}) {
    return DropdownButtonFormField<String>(
      value: _gender,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      items: ['Female', 'Male', 'Other'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: enabled
          ? (String? newValue) {
              setState(() {
                _gender = newValue!;
              });
            }
          : null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your gender';
        }
        return null;
      },
    );
  }
}
