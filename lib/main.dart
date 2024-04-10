import 'package:debug_it/features/user_auth/presentation/pages/delete.dart';
import 'package:debug_it/features/user_auth/presentation/pages/home_page.dart';
import 'package:debug_it/features/user_auth/presentation/pages/login_page.dart';
import 'package:debug_it/features/user_auth/presentation/pages/signup_page.dart';


import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      navigatorKey: navigatorKey, // Assigning the navigatorKey to the MaterialApp
      initialRoute: '/', // Initial route is SignUpPage
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/delete': (context) => DeleteAccount(),
        '/': (context) => SignUpPage(), // Default route is SignUpPage
      },
    );
  }
}