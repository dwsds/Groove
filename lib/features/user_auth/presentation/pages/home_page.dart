import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'api_music.dart';
import 'yourlibrary.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      ApiPage(user: widget.user,),
      YourLibrary(user: widget.user,),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade600,
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey.shade900,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore, color: Colors.deepPurple,),
            label: 'Explore',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books,color: Colors.deepPurple),
            label: 'Your Libraries',
          ),
        ],
      ),
    );
  }
}
