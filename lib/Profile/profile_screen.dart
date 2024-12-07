// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tubulert_web_ap/auth/signin_Page.dart';
import 'package:tubulert_web_ap/colors/colors.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final name = TextEditingController();
  final designation = TextEditingController();
  final phoneNo = TextEditingController();
  final bloodGroup = TextEditingController();
  final hospital = TextEditingController();
  final yearOfExp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Screen dimensions for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: cuspink,
        elevation: 0,
        title: const Text(
          'Tubulert',
          style: TextStyle(fontWeight: FontWeight.bold, color: white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 1.w,
              backgroundImage: NetworkImage(
                  'lib/assets/doc67.png'), // Update with your asset path
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!
                    .uid) // Replace with the specific user ID
                .snapshots(),
            builder: (context, snapshot) {
              // Check if the snapshot has data
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error fetching data.'));
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(child: Text('No data available.'));
              } else if (snapshot.hasData) {
                final userData = snapshot.data!.data() as Map<String, dynamic>;

                name.text = userData['fullName'] ?? '';
                designation.text = userData['designation'] ?? '';
                phoneNo.text = userData['phoneNo'] ?? '';
                bloodGroup.text = userData['bloodGroup'] ?? '';
                hospital.text = userData['hospital'] ?? '';
                yearOfExp.text = userData['yearOfExp'] ?? '';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Doctor's Image and Details
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                          horizontal: screenWidth * 0.05),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 3.w,
                            backgroundImage: NetworkImage(
                                'lib/assets/doc89.png'), // Update path
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            'Dr. James',
                            style: TextStyle(
                              fontSize: 2.w,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            userData['designation'] ?? '',
                            style: TextStyle(
                              fontSize: 1.5.w,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    // Form fields
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenWidth * 0.02),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Name',
                                    style: TextStyle(
                                      fontSize: 1.5.w,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.05),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: name,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 1.h, horizontal: 4.w),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenWidth * 0.02),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Designation',
                                    style: TextStyle(
                                      fontSize: 1.5.w,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.05),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: designation,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 1.h, horizontal: 4.w),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenWidth * 0.02),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Phone',
                                    style: TextStyle(
                                      fontSize: 1.5.w,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.05),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: phoneNo,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 1.h, horizontal: 4.w),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenWidth * 0.02),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Blood Group',
                                    style: TextStyle(
                                      fontSize: 1.5.w,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.05),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: bloodGroup,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 1.h, horizontal: 4.w),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenWidth * 0.02),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Hospital',
                                    style: TextStyle(
                                      fontSize: 1.5.w,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.05),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: hospital,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 1.h, horizontal: 4.w),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: screenWidth * 0.02),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Years of Expeience',
                                    style: TextStyle(
                                      fontSize: 1.5.w,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.05),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: yearOfExp,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 1.h, horizontal: 4.w),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // Sign Up Button
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
                      child: ElevatedButton(
                        onPressed: () async {
                          // Reference to Firestore
                          final firestore = FirebaseFirestore.instance;

                          // Assuming the user's document ID is known and stored in a variable
                          final userId = FirebaseAuth.instance.currentUser!.uid;

                          try {
                            await firestore
                                .collection('users')
                                .doc(userId)
                                .update({
                              'fullName': name.text,
                              'designation': designation.text,
                              'phoneNo': phoneNo.text,
                              'bloodGroup': bloodGroup.text,
                              'hospital': hospital.text,
                              'yearOfExp': yearOfExp.text,
                            });
                            // Show a success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'User information updated successfully!')),
                            );
                          } catch (e) {
                            // Handle errors, for example, by showing an error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Failed to update user information: $e')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 3.w),
                          backgroundColor: cuspink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 2.w,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInPage(),
                              ),
                              (route) => false,
                            );
                            // Show a success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Logout Successful!')),
                            );
                          } catch (e) {
                            // Handle errors, for example, by showing an error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed: $e')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 3.w),
                          backgroundColor: cuspink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 2.w,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(child: Text('Error fetching data.'));
              }
            }),
      ),
    );
  }
}
