import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:my_prg/utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 70, 205, 236),
        centerTitle: true,
        elevation: 0,
        title: Text(
          "WELCOME STUDENTS ",
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                // Navigate to Reminder screen
                Navigator.pushNamed(context, '/home'); // Assuming '/home' is the reminder screen
              },
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: 20),
                color: Colors.blue,
                child: Text(
                  'Go to Reminder',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // Navigate to To-Do List screen
                Navigator.pushNamed(context, '/todo'); // Assuming '/todo' is the to-do list screen
              },
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.green,
                child: Text(
                  'Go to To-Do List',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
