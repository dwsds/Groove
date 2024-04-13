import 'package:debug_it/features/user_auth/presentation/pages/api_music.dart';
import 'package:debug_it/features/user_auth/presentation/pages/delete.dart';
import 'package:debug_it/features/user_auth/presentation/pages/local_music.dart';
import 'package:debug_it/features/user_auth/presentation/pages/login_page.dart';
import 'package:debug_it/features/user_auth/presentation/pages/selectPlaylist.dart';
import 'package:debug_it/features/user_auth/presentation/pages/signup_page.dart';
import 'package:debug_it/features/user_auth/presentation/pages/welcome_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:debug_it/features/user_auth/presentation/pages/yourlibrary.dart';
import 'package:debug_it/features/user_auth/presentation/widgets/inherited_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        '/local': (context) => LocalMusic(),
        // '/home': (context) => HomePage(),
        '/api_music': (context) => ApiPage(user: ModalRoute.of(context)!.settings.arguments as User),
        '/library': (context) => YourLibrary(user: ModalRoute.of(context)!.settings.arguments as User),
        '/delete': (context) => DeleteAccount(),
        '/signup': (context) => SignUpPage(),
        '/': (context) => WelcomeScreen(), // Default route is SignUpPage
      },
    );
  }
}


