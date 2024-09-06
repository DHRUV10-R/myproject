import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:my_prg/main.dart';
import '../Widgets/add_reminder.dart';
import '../Widgets/delete_reminder.dart';
import '../Widgets/switcher.dart';
import '../services/notification_logic.dart';
import '../utils/app_colors.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  User? user;
  bool on = true;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      NotificationLogic.init(context, user!.uid);
      listenNotification();
    }
  }

  void listenNotification() {
    NotificationLogic.onNotification.listen((value) {});
  }

  void onClickedNotification(String? payload) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
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
            if (user != null) {
              addReminder(context, user!.uid);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.primaryG,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
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
        body: user == null
            ? Center(child: Text("User not authenticated"))
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(user!.uid)
                    .collection('reminder')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF4FA8C5)),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text("Nothing to Show"),
                    );
                  }

                  final data = snapshot.data!;
                  return ListView.builder(
                    itemCount: data.docs.length,
                    itemBuilder: (context, index) {
                      final doc = data.docs[index];
                      final Timestamp t = doc.get('time');
                      final DateTime date = DateTime.fromMicrosecondsSinceEpoch(
                          t.microsecondsSinceEpoch);
                      final String formattedTime = DateFormat.jm().format(date);
                      final bool on = doc.get('onOff');

                      if (on) {
                        NotificationLogic.showNotification(
                          dateTime: date,
                          id: 0,
                          title: "Reminder Title",
                          body: "Don't Forget to Complete the Task",
                        );
                      }

                      return Padding(
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
                                  Switcher(
                                      on, user!.uid, doc.id, doc.get('time')),
                                  IconButton(
                                    onPressed: () {
                                      deleteReminder(
                                          context, doc.id, user!.uid);
                                    },
                                    icon: FaIcon(FontAwesomeIcons.circleXmark),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
