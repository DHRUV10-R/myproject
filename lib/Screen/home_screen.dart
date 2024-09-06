

import 'package:flutter/material.dart';
import 'package:my_prg/utils/app_colors.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 70, 205, 236),
        centerTitle: true,
        elevation: 0,
        title: Text(
          "WELCOME STUDENTS",
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
                Navigator.pushNamed(context, '/rem'); // Ensure '/home' is defined in your routes
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
                Navigator.pushNamed(context, '/todo'); // Ensure '/todo' is defined in your routes
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
