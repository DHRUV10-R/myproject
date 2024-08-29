// profile_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User? user = FirebaseAuth.instance.currentUser;
  final _nameController = TextEditingController();
  final _photoUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with current user info
    if (user != null) {
      _nameController.text = user!.displayName ?? '';
      _photoUrlController.text = user!.photoURL ?? '';
    }
  }

  Future<void> _updateProfile() async {
    if (user == null) return;

    try {
      await user!.updateProfile(
        displayName: _nameController.text,
        photoURL: _photoUrlController.text,
      );
      await user!.reload(); // Reload user to reflect changes
      user = FirebaseAuth.instance.currentUser; // Refresh user info
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _photoUrlController.text.isNotEmpty
                    ? NetworkImage(_photoUrlController.text)
                    : null,
                child: _photoUrlController.text.isEmpty
                    ? Icon(Icons.person, size: 50)
                    : null,
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
            SizedBox(height: 10),
            Text(
              'Profile Picture URL:',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _photoUrlController,
              decoration: InputDecoration(
                hintText: 'Enter profile picture URL',
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
    );
  }
}
