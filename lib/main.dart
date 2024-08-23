// // ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screen/home_screen.dart';
import 'Screen/login_screen.dart';
import 'Screen/news_screen.dart';
import 'Screen/quiz_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ScholarNexus",
      debugShowCheckedModeBanner: false,
      home: _auth.currentUser != null ? MyHomePage() : LoginScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => MyHomePage());
          case '/login':
            return MaterialPageRoute(builder: (context) => LoginScreen());
          case '/home':
            return MaterialPageRoute(builder: (context) => HomeScreen());
          case '/quiz':
            return MaterialPageRoute(
                builder: (context) => QuizScreen(
                    questionlenght: [], optionsList: null, topicType: ''));
          case '/news':
            return MaterialPageRoute(builder: (context) => NewsScreen());
          default:
            return MaterialPageRoute(builder: (context) => MyHomePage());
        }
      },
    );
  }
}

void _onMenuItemSelected(String value) {
  // Handle menu item selection here
  print("Selected menu item: $value");
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    QuizScreen(questionlenght: [3], optionsList: 4, topicType: '2'),
    NewsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scholar Nexus'),
        leading: IconButton(
          icon: const Icon(Icons.account_box),
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _onMenuItemSelected,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Option 1',
                  child: Row(
                    children: [
                      Icon(Icons.settings, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Option 1'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Option 2',
                  child: Row(
                    children: [
                      Icon(Icons.help, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Option 2'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
