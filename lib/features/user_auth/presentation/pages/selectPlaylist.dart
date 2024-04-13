import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:debug_it/features/user_auth/presentation/widgets/inherited_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:debug_it/features/user_auth/models/MusicDataResponse.dart';

class CreateNewPlaylistPage extends StatelessWidget {
  final String userID;
  final MusicDataResponse currentSong;

  const CreateNewPlaylistPage({
    Key? key,
    required this.userID,
    required this.currentSong,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? playlistName;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Playlist'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Show dialog to get playlist name
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Enter Playlist Name'),
                  content: TextField(
                    onChanged: (value) {
                      // Store the entered playlist name
                      playlistName = value;
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Call _createNewPlaylist with the entered playlist name
                        _createNewPlaylist(context, playlistName!);
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Create'),
                    ),
                  ],
                );
              },
            );
          },
          child: Text('Create New Playlist'),

        ),



      ),
    );
  }

  void _createNewPlaylist(BuildContext context, String name) async {
    try {
      CollectionReference playlistsCollection =
      FirebaseFirestore.instance.collection('playlists');

      // Check if the playlist document already exists
      DocumentSnapshot playlistDoc =
      await playlistsCollection.doc(userID).get();

      if (!playlistDoc.exists) {
        // Create a new document for the user if it doesn't exist
        print('Debug: Playlist document does not exist. Creating new document...');
        await playlistsCollection.doc(userID).set(<String, dynamic>{
          // Add initial data if needed
        });

        print('Debug: New playlist document created successfully.');
      } else {
        print('Debug: Playlist document already exists.');
      }

      // Add the current song to the playlist
      await playlistsCollection.doc(userID).collection(name).doc(currentSong.id).set({
        'songName': currentSong.title.toString(),
        'artist': currentSong.artist,
        'createdAt': FieldValue.serverTimestamp(), // Add creation timestamp
        // Add other song details as needed
      } as Map<String, dynamic>); // Ensure the data type is explicitly specified

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New playlist created successfully!'),
        ),
      );
    } catch (e) {
      print('Error creating playlist: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating playlist: $e'),
        ),
      );
    }
  }






}
