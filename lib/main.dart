import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Screen/Notes_screen.dart';
import 'Screen/StudyAssistantScreen.dart';
import 'Screen/home_screen.dart';
import 'Screen/login_screen.dart';
import 'Screen/news_screen.dart';
import 'Screen/profile_screen.dart';
import 'Screen/quiz_screen.dart';
import 'Screen/reminder.dart';
import 'Screen/todo_list_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
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

  @override
  void initState() {
    super.initState();
    
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logged out successfully!')),
    );
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Scholar Nexus",
      debugShowCheckedModeBanner: false,
      theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: _auth.currentUser != null
          ? MyHomePage(
              auth: _auth,
              showAboutPage: _showAboutPage,
              logout: _logout,
            )
          : LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/quiz': (context) => QuizScreen(),
        '/news': (context) => NewsScreen(),
        '/profile': (context) => ProfileScreen(),
        '/todo': (context) => ToDoListScreen(),
        '/rem': (context) => ReminderScreen(),
        '/notes': (context) => NotesScreen(),
        '/studyAssistant': (context) => StudyAssistantScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final FirebaseAuth auth;
  final Function showAboutPage;
  final Function logout;

  const MyHomePage({
    super.key,
    required this.auth,
    required this.showAboutPage,
    required this.logout,
  });

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
    if (value == 'About') {
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
        backgroundColor: Color.fromARGB(255, 70, 205, 236),
        title: Text('Scholar Nexus',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: widget.auth.currentUser == null
            ? TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.black),
                ),
              )
            : Container(),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _onMenuItemSelected,
            itemBuilder: (BuildContext context) {
              return [
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
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
  backgroundColor: Color.fromARGB(255, 70, 205, 236), // Set background color
  selectedItemColor: Color.fromARGB(255, 70, 205, 236), // Set selected item color
  unselectedItemColor: const Color.fromARGB(137, 81, 80, 80),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz, size: 30),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper, size: 30),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 10,
      ),
    );
  }
}
