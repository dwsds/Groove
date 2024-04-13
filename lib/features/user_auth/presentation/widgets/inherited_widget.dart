import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:debug_it/features/user_auth/models/MusicDataResponse.dart';

class MusicDataWidget extends InheritedWidget {
  final User user;
  final MusicDataResponse currentSong;
  final Function(String) createNewPlaylist;

  const MusicDataWidget({
    Key? key,
    required this.user,
    required this.currentSong,
    required this.createNewPlaylist,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static MusicDataWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MusicDataWidget>();
  }
}
