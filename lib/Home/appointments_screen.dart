// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sort_child_properties_last, library_private_types_in_public_api

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tubulert_web_ap/colors/colors.dart';

class AppointmentsScreen extends StatefulWidget {
  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
  }

  // Fetch upcoming appointments for the doctor
  Stream _getUpcomingAppointments() {
    final currentTimestamp = Timestamp.fromDate(DateTime.now());
    return _firestore
        .collection('appoinments')
        .where('did', isEqualTo: _currentUser.uid) // Filter by doctor
        .where('status',
            isEqualTo: 'Approved') // Status for upcoming appointments
        .where('time', isGreaterThan: currentTimestamp) // Filter by future time
        .snapshots();
  }

  // Fetch appointment requests for the doctor
  Stream _getAppointmentRequests() {
    return _firestore
        .collection('appoinments')
        .where('did', isEqualTo: _currentUser.uid)
        .where('status',
            isEqualTo: 'Pending') // Appointment requests awaiting confirmation
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cuspink,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Welcome\nDr. James",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CircleAvatar(
                  radius: screenWidth * 0.05,
                  backgroundImage: NetworkImage(
                    'lib/assets/doctor-with-his-arms-cross.png', // Replace with actual image
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 18,
          ),

          // Two Columns: Upcoming Appointments and Appointment Requests
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Upcoming Appointments
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Upcoming Appointments",
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 11),
                      StreamBuilder(
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
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
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

                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.grey[300],
                                      child: Icon(Icons.person,
                                          color: Colors.black),
                                    ),
                                    title: StreamBuilder(
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
                                    trailing: ElevatedButton(
                                      onPressed: () {
                                        // Logic to join the appointment
                                      },
                                      child: Text(
                                        "$formattedDate $formattedTime",
                                        style: TextStyle(color: white),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: cuspink,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Appointment Requests
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Appointment Requests",
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 11),
                      StreamBuilder(
                        stream: _getAppointmentRequests(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(
                                child: Text("No appointment requests."));
                          } else {
                            final requests = snapshot.data!.docs;

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: requests.length,
                              itemBuilder: (context, index) {
                                var request = requests[index];

                                DateTime dateTime =
                                    requests[index]['time'].toDate();

                                // Format Date and Time
                                String formattedDate =
                                    "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
                                String formattedTime =
                                    "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.grey[300],
                                      child: Icon(Icons.person,
                                          color: Colors.black),
                                    ),
                                    title: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(requests[index]['pid'])
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Text(
                                              'Loading...'); // Show a loading message while waiting for data.
                                        }
                                        if (snapshot.hasError) {
                                          print(snapshot.error);
                                          return Text(
                                              'Error: ${snapshot.error}'); // Show an error message if there's an error.
                                        }
                                        if (!snapshot.hasData ||
                                            snapshot.data == null) {
                                          return Text(
                                              'No data available'); // Handle the case when there's no data.
                                        }

                                        // Safely access snapshot data after null checks.
                                        final userData = snapshot.data!.data();
                                        final fullName =
                                            userData!['first_name'] ??
                                                'No name provided';

                                        return Text(
                                            fullName); // Display the user's full name.
                                      },
                                    ),
                                    subtitle:
                                        Text('$formattedDate $formattedTime'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.check,
                                              color: Colors.green),
                                          onPressed: () {
                                            // Logic to accept the appointment request
                                            _firestore
                                                .collection('appoinments')
                                                .doc(request.id)
                                                .update({
                                              'status':
                                                  'Approved', // Update status to Upcoming
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.close,
                                              color: Colors.red),
                                          onPressed: () {
                                            // Logic to reject the appointment request
                                            _firestore
                                                .collection('appoinments')
                                                .doc(request.id)
                                                .update({
                                              'status':
                                                  'Rejected', // Update status to Rejected
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
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
