import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_prg/Screen/quiz_screen.dart';
import 'Screen/login_screen.dart';
import 'Screen/news_screen.dart';
import 'Screen/profile_screen.dart';
import 'Screen/todo_list_screen.dart';  
import 'Screen/home_screen.dart';  
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isDarkTheme = false;

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  void _showAboutPage(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Scholar Nexus',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(Icons.school, size: 50),
      children: [
        Text(
          'Scholar Nexus is an interactive learning app that helps students stay organized and engaged.',
        ),
      ],
    );
  }

  void _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ScholarNexus",
      debugShowCheckedModeBanner: false,
      theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: _auth.currentUser != null
          ? MyHomePage(toggleTheme: _toggleTheme, showAboutPage: _showAboutPage, logout: _logout)
          : LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),  
        '/quiz': (context) => QuizScreen(),
        '/news': (context) => NewsScreen(),
        '/profile': (context) => ProfileScreen(),
        '/todo': (context) => ToDoListScreen(),  
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Function toggleTheme;
  final Function showAboutPage;
  final Function logout;

  MyHomePage({required this.toggleTheme, required this.showAboutPage, required this.logout});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),  
    QuizScreen(),
    NewsScreen(),
    ProfileScreen(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onMenuItemSelected(String value) {
    if (value == 'Theme') {
      widget.toggleTheme();
    } else if (value == 'About') {
      widget.showAboutPage(context);
    } else if (value == 'Logout') {
      widget.logout(context);
    } else if (value == 'Profile') {
      Navigator.pushNamed(context, '/profile');
    }
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
                  value: 'Theme',
                  child: Row(
                    children: [
                      Icon(Icons.brightness_6, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Theme'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Profile',
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Profile'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'About',
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('About'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Logout'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: _widgetOptions[_selectedIndex],  // Dynamically update body based on the selected tab
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 143, 134, 134), 
        selectedItemColor: Color.fromARGB(255, 33, 203, 53), 
        unselectedItemColor: Color.fromARGB(255, 32, 123, 197),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
