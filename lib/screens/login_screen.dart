import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import '../screens/home_screen.dart';
import '../screens/update_app_user_screen.dart';
import '../utilities/firebase_calls.dart';
import '../models/app_user.dart';
import '../utilities/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Background,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // Wrap the SignInScreen in a Theme to force firebase_ui_auth to use custom styles
            // Suggested by Gemini AI
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.Primary,
                ),
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: AppColors.Primary, width: 2.0),
                  ),
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.Primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 2,
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.Primary,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                outlinedButtonTheme: OutlinedButtonThemeData(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.Primary,
                    side: BorderSide(color: AppColors.Primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              child: SignInScreen(
                providers: [
                  EmailAuthProvider(),
                ],
                headerMaxExtent: 220,
                headerBuilder: (context, constraints, shrinkOffset) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.Primary,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Icon(
                          Icons.health_and_safety_rounded,
                          size: 90,
                          color: Colors.white,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Healthcare App',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            //check if User is found in appUsers collection
            return FutureBuilder<AppUser>(
              future: FirebaseCalls().getAppUser(snapshot.data!.uid),
              builder: (context, snapshot2) {
                if (snapshot2.hasData) {
                  if (newUser) {
                    return const UpdateAppUserScreen();
                  } else {
                    return const HomeScreen();
                  }
                } else if (snapshot2.hasError) {
                  return Text('${snapshot2.error}');
                }
                return const CircularProgressIndicator();
              },
            );
          }
        },
      ),
    );
  }
}