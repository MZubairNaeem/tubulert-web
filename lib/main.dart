// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tubulert_web_ap/Home/home_screen.dart';
import 'package:tubulert_web_ap/Profile/profile_screen.dart';
import 'package:tubulert_web_ap/For/res/pass/forgot_password_page_code.dart';
import 'package:tubulert_web_ap/auth/signin_Page.dart';
import 'package:tubulert_web_ap/auth/signup_page.dart';
import 'package:tubulert_web_ap/For/res/pass/reset_password_page_code.dart';
import 'firebase_options.dart'; // Ensure this file is in your `lib` folder.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tubulert',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(
                color: Colors.white, // Set leading icon color to white
              ),
            ),
          ),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              // Check if the connection state is active
              if (snapshot.connectionState == ConnectionState.active) {
                // If the user is authenticated, navigate to HomeScreen
                if (snapshot.hasData) {
                  return HomeScreen();
                }
                // If not authenticated, navigate to LoginScreen
                return SignInPage();
              }

              // Show a loading indicator while checking authentication state
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
