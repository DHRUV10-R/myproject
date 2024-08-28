import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_prg/utils/app_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models_reminder/remainder_model.dart';

addReminder(BuildContext context, String uid) {
  TimeOfDay time = TimeOfDay.now();
  add(String uid, TimeOfDay time) {
    try {
      DateTime d = DateTime.now();
      DateTime dateTime =
          DateTime(d.year, d.month, d.day, time.hour, time.minute);
      Timestamp timestamp = Timestamp.fromDate(dateTime);
      ReminderModel reminderModel = ReminderModel();
      reminderModel.timestamp = timestamp;
      reminderModel.onOff = false;
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('reminder')
          .doc()
          .set(reminderModel.toMap());

      Fluttertoast.showToast(msg: "Reminder Added");
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) setState) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              title: Text("Add Reminder"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Text("Select a time for Reminder"),
                    SizedBox(height: 20),
                    MaterialButton(
                      onPressed: () async {
                        TimeOfDay? newTime = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());

                        if (newTime == null) return;
                        setState(() {
                          time = newTime;
                        });
                      },
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.clock,
                            color: AppColors.primary_Color1,
                            size: 40,
                          ),
                          SizedBox(width: 10),
                          Text(
                            time.format(context).toString(),
                            style: TextStyle(
                              color: AppColors.primary_Color1,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    add(uid, time);
                    Navigator.pop(context);
                  },
                  child: Text("Add"),
                ),
              ]);
        },
      );
    },
  );
}
