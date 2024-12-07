// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tubulert_web_ap/Profile/profile_screen.dart';
import 'package:tubulert_web_ap/colors/colors.dart';
import 'appointments_screen.dart';
import 'patients_screen.dart';
import 'booking_history_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: cuspink,
          title: const Text(
            "Tubulert",
            style: TextStyle(color: white),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, color: white),
            tabs: [
              Tab(text: "Appointments"),
              Tab(text: "Patients"),
              Tab(text: "Booking History"),
            ],
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage('lib/assets/doc67.png'),
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: cuspink,
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: TabBarView(
          children: [
            AppointmentsScreen(),
            PatientsScreen(),
            BookingHistoryScreen(),
          ],
        ),
      ),
    );
  }
}
