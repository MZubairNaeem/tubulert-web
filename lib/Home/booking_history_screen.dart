// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BookingHistoryScreen extends StatefulWidget {
  @override
  _BookingHistoryScreenState createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
  }

  Stream _getUpcomingAppointments() {
    final currentTimestamp = Timestamp.fromDate(DateTime.now());
    return _firestore
        .collection('appoinments')
        .where('did', isEqualTo: _currentUser.uid) // Filter by doctor
        .where('status',
            isEqualTo: 'Approved') // Status for upcoming appointments
        .where('time', isLessThan: currentTimestamp) // Filter by future time
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            child: Row(
              children: [
                // Upcoming Appointments
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 2.h),
                        color: Colors.grey
                            .withOpacity(0.1), // Light background shade
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Name'),
                            Text('Appointment Date'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 2.h),
                        child: StreamBuilder(
                          stream: _getUpcomingAppointments(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              print(snapshot.error);
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data == null ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(
                                  child: Text("No upcoming appointments."));
                            } else {
                              final appointments = snapshot.data!.docs;
                              log(appointments.length.toString());
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: appointments.length,
                                itemBuilder: (context, index) {
                                  final pid = appointments[index]['pid'];
                                  if (pid == null) {
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: ListTile(
                                        title: Text("Missing PID"),
                                      ),
                                    );
                                  }
                                  DateTime dateTime =
                                      appointments[index]['time'].toDate();
                                  // Format Date and Time
                                  String formattedDate =
                                      "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
                                  String formattedTime =
                                      "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";

                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(pid)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Text('Loading...');
                                          } else if (snapshot.hasError) {
                                            print(snapshot.error);
                                            return Text(
                                                'Errors: ${snapshot.error}');
                                          } else if (!snapshot.hasData ||
                                              snapshot.data!.data() == null) {
                                            return Text(
                                                'No user data available.');
                                          } else {
                                            final userData =
                                                snapshot.data!.data()!;
                                            final fullName =
                                                userData['first_name'] ??
                                                    'No name provided';
                                            log(fullName.toString());
                                            return Text(fullName);
                                          }
                                        },
                                      ),
                                      Text(
                                        "$formattedDate $formattedTime",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
