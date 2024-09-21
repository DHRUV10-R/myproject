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
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCard(
              title: 'Go to Reminder',
              color: Colors.blueAccent,
              icon: Icons.alarm,
              onTap: () {
                Navigator.pushNamed(context, '/rem');
              },
            ),
            SizedBox(height: 20),
            _buildCard(
              title: 'Go to To-Do List',
              color: Colors.green,
              icon: Icons.check_circle_outline,
              onTap: () {
                Navigator.pushNamed(context, '/todo');
              },
            ),
            SizedBox(height: 20),
            _buildCard(
              title: 'Go to Notes',
              color: Colors.orange,
              icon: Icons.note,
              onTap: () {
                Navigator.pushNamed(context, '/notes');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({String title, Color color, IconData icon, Function onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 30, color: Colors.white),
              SizedBox(width: 20),
              Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
