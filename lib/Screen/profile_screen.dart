import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User? user = FirebaseAuth.instance.currentUser;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _schoolController = TextEditingController();
  final _majorController = TextEditingController();
  final _bioController = TextEditingController();
  String _selectedYear = 'Freshman';
  final ImagePicker _picker = ImagePicker();
  String? _photoUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _nameController.text = user!.displayName ?? '';
      _emailController.text = user!.email ?? '';
      _photoUrl = user!.photoURL;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _isUploading = true;
      });

      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pictures')
            .child(user!.uid + '.jpg');
        await storageRef.putFile(File(pickedFile.path));
        String downloadUrl = await storageRef.getDownloadURL();

        await user!.updateProfile(photoURL: downloadUrl);
        await user!.reload();
        user = FirebaseAuth.instance.currentUser;

        setState(() {
          _photoUrl = downloadUrl;
          _isUploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture updated successfully')),
        );
      } catch (e) {
        setState(() {
          _isUploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    }
  }

  Future<void> _updateProfile() async {
    if (user == null) return;

    try {
      await user!.updateProfile(
        displayName: _nameController.text,
        photoURL: _photoUrl,
      );
      await user!.reload();
      user = FirebaseAuth.instance.currentUser;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _photoUrl != null ? NetworkImage(_photoUrl!) : null,
                      child: _photoUrl == null
                          ? Icon(Icons.person, size: 50)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: _isUploading ? null : _pickImage,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Name:',
                style: TextStyle(fontSize: 18),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Email:',
                style: TextStyle(fontSize: 18),
              ),
              TextField(
                controller: _emailController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Your email',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Phone Number:',
                style: TextStyle(fontSize: 18),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: 'Enter your phone number',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'School/University:',
                style: TextStyle(fontSize: 18),
              ),
              TextField(
                controller: _schoolController,
                decoration: InputDecoration(
                  hintText: 'Enter your school or university',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Major/Subjects:',
                style: TextStyle(fontSize: 18),
              ),
              TextField(
                controller: _majorController,
                decoration: InputDecoration(
                  hintText: 'Enter your major or key subjects',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Year of Study:',
                style: TextStyle(fontSize: 18),
              ),
              DropdownButton<String>(
                value: _selectedYear,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedYear = newValue!;
                  });
                },
                items: <String>[
                  'Freshman',
                  'Sophomore',
                  'Junior',
                  'Senior',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Text(
                'Bio:',
                style: TextStyle(fontSize: 18),
              ),
              TextField(
                controller: _bioController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter a short bio',
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _updateProfile,
                  child: Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
