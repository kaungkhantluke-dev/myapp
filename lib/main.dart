import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:medquiz/loginUI/signup.dart';
import 'package:medquiz/loginUI/login.dart';
import 'package:medquiz/loginUI/landingpage.dart';
import 'package:medquiz/loginUI/chgpassword.dart';
import 'package:medquiz/loginUI/feedpage.dart';
import 'package:medquiz/loginUI/admin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Q&A App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const LogIn(),
        '/signup': (context) => const SignUp(),
        '/chgpassword': (context) => const ChgPassword(),
        '/feedpage': (context) => const FeedPage(),
        '/admin': (context) => const AdminDashboardScreen(),
      },
    );
  }
}
