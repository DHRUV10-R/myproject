import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  String? _downloadUrl;

  Future<void> _uploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _isUploading = true;
      });

      File file = File(pickedFile.path);
      try {
        // Create a reference to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

        // Upload the file
        UploadTask uploadTask = storageRef.putFile(file);

        // Wait until the upload is complete
        await uploadTask;

        // Get the download URL
        _downloadUrl = await storageRef.getDownloadURL();

        setState(() {
          _isUploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload successful!')),
        );
      } catch (e) {
        setState(() {
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isUploading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _uploadImage,
                    child: Text('Select and Upload Image'),
                  ),
            if (_downloadUrl != null) ...[
              SizedBox(height: 20),
              Text('Download URL:'),
              Text(_downloadUrl!),
            ],
          ],
        ),
      ),
    );
  }
}
