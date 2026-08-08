import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:healthcare/screens/news_screen.dart';
import 'firebase_options.dart';

import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/clinics_screen.dart';
import '../screens/update_app_user_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
//wigger
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/clinics': (context) => const ClinicsScreen(),
        '/user': (context) => const UpdateAppUserScreen(),
        '/news': (context) => const NewsScreen(),
      },
    );
  }
}
