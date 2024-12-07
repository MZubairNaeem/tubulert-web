import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package
import 'package:tubulert_web_ap/auth/signin_Page.dart';
import 'package:tubulert_web_ap/colors/colors.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  // Firebase Authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Create User
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Save User Data to Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'fullName': _fullNameController.text.trim(),
          'email': _emailController.text.trim(),
          'userType': 'Doctor', // Web registration => userType: Doctor
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Navigate to SignInPage or HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account Created Successfully')));
      } on FirebaseAuthException catch (e) {
        String errorMessage = "Registration failed. Please try again.";
        if (e.code == 'email-already-in-use') {
          errorMessage = "The email is already in use.";
        } else if (e.code == 'weak-password') {
          errorMessage = "The password is too weak.";
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          children: [
            // Left Form Section
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tubulert Logo/Text
                      Text(
                        'Tubulert',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      // Heading
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      // Full Name Input Field
                      TextFormField(
                        controller: _fullNameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          labelStyle: TextStyle(fontSize: screenWidth * 0.025),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.01),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your full name.";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // Email Input Field
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(fontSize: screenWidth * 0.025),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.01),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email.";
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return "Please enter a valid email.";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // Password Input Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(fontSize: screenWidth * 0.025),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.01),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password.";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters.";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // Confirm Password Input Field
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(fontSize: screenWidth * 0.025),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.01),
                          ),
                        ),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return "Passwords do not match.";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      // Sign-Up Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cuspink,
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.025,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.02),
                            ),
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Sign up',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.025,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Right Image Section
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Image.network(
                  'lib/assets/doctor_team.png', // Replace with your local asset path
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
