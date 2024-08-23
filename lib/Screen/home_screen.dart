import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:my_prg/Widgets/add_reminder.dart';

import 'package:my_prg/services/notification_logic.dart';
import 'package:my_prg/utils/app_colors.dart';

import '../Widgets/delete_reminder.dart';
import '../Widgets/switcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user;
  bool on = true;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    NotificationLogic.init(context, user!.uid);
    listenNotification();
  }

  void listenNotification() {
    NotificationLogic.onNotification.listen((value) {});
  }

  void onClickedNotification(String? payload) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Define the action when the back button is pressed
              Navigator.pop(context);
            },
          ),
          backgroundColor: AppColors.whiteColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            "Reminder",
            style: TextStyle(
              color: AppColors.blackColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          onPressed: () async {
            addReminder(context, user!.uid);
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: AppColors.primaryG,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(user!.uid)
              .collection('reminder')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4FA8C5)),
                ),
              );
            }

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text("Nothing to Show"),
              );
            }
            final data = snapshot.data;
            return ListView.builder(
              itemCount: data!.docs.length,
              itemBuilder: (context, index) {
                Timestamp t = data.docs[index].get('time');
                DateTime date = DateTime.fromMicrosecondsSinceEpoch(
                    t.microsecondsSinceEpoch);
                String formattedTime = DateFormat.jm().format(date);
                on = data.docs[index].get('onOff');
                if (on) {
                  NotificationLogic.showNotification(
                      dateTime: date,
                      id: 0,
                      title: "Reminder Title",
                      body: "Don \'t Forget to Completion of Task");
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Card(
                          child: ListTile(
                            title: Text(
                              formattedTime,
                              style: TextStyle(fontSize: 30),
                            ),
                            subtitle: Text("Everyday"),
                            trailing: Container(
                              width: 110,
                              child: Row(
                                children: [
                                  Switcher(on, user!.uid, data.docs[index].id,
                                      data.docs[index].get('time')),
                                  IconButton(
                                    onPressed: () {
                                      deleteReminder(context,
                                          data.docs[index].id, user!.uid);
                                    },
                                    icon: FaIcon(FontAwesomeIcons.circleXmark),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
