import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unibook/pages/auth_page.dart';
import 'package:unibook/pages/profile_page.dart';
import 'package:unibook/pages/register_page.dart';
import 'firebase_options.dart';
import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'package:fluttery_timber/debug_tree.dart';
import 'package:fluttery_timber/timber.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  _setupLogger();
  runApp(const MyApp());
}

void _setupLogger() {
  if (kDebugMode) {
    Timber.plantTree(DebugTree());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unibook',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashPage(),
        '/auth': (context) => const AuthPage(),
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage()
      },
    );
  }
}
