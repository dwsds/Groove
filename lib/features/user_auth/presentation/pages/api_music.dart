import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:debug_it/features/user_auth/models/music.dart';
import 'package:debug_it/features/user_auth/presentation/pages/home.dart';
import 'package:debug_it/features/user_auth/presentation/pages/search.dart';
import 'package:debug_it/features/user_auth/presentation/pages/yourlibrary.dart';

class SpotifyApp extends StatefulWidget {
  const SpotifyApp({Key? key}) : super(key: key);

  @override
  _SpotifyAppState createState() => _SpotifyAppState();
}

class _SpotifyAppState extends State<SpotifyApp> {
  AudioPlayer _audioPlayer = AudioPlayer();
  var tabs = [
    Home((music, {stop = false}) {
      // Your mini player logic here
    }),
    Search(),
    YourLibrary()
  ];

  int currentTabIndex = 0;
  bool isPlaying = false;
  Music? music;

  Widget miniPlayer(Music? music, {bool stop = false}) {
    this.music = music;

    if (music == null) {
      return SizedBox();
    }

    if (stop) {
      isPlaying = false;
      _audioPlayer.stop();
    }

    setState(() {});

    Size deviceSize = MediaQuery.of(context).size;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: Colors.blueGrey,
      width: deviceSize.width,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.network(music.image, fit: BoxFit.cover),
          Text(
            music.name,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          IconButton(
            onPressed: () async {
              isPlaying = !isPlaying;

              if (isPlaying) {
                await _audioPlayer.play(music.audioURL as Source);
              } else {
                await _audioPlayer.pause();
              }

              setState(() {});
            },
            icon: isPlaying
                ? Icon(Icons.pause, color: Colors.white)
                : Icon(Icons.play_arrow, color: Colors.white),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Let's Build it");

    return Scaffold(
      body: tabs[currentTabIndex],
      backgroundColor: Colors.black,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          miniPlayer(music),
          BottomNavigationBar(
            currentIndex: currentTabIndex,
            onTap: (currentIndex) {
              print("Current Index is $currentIndex");
              currentTabIndex = currentIndex;
              setState(() {}); // re-render
            },
            selectedLabelStyle: TextStyle(color: Colors.white),
            selectedItemColor: Colors.white,
            backgroundColor: Colors.black45,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.white),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search, color: Colors.white),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_books, color: Colors.white),
                label: 'Your Library',
              ),
            ],
          )
        ],
      ),
    );
  }
}
