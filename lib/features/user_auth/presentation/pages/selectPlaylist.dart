import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debug_it/features/user_auth/presentation/pages/playlistsdetails.dart';
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
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
          SizedBox(height: 20), // Add spacing between the button and text
          Text(
            'Add to already existing playlist',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10), // Add spacing before the playlist content
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection(userID).get(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error fetching playlists: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No playlists found for user $userID');
                }
                List<String> playlistIDs = snapshot.data!.docs.map((doc) => doc.id).toList();
                List<String> playlistNames = [];
                snapshot.data!.docs.forEach((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  if (data.containsKey('PlaylistName')) {
                    playlistNames.add(data['PlaylistName']);
                  }
                });
                print('Playlist IDs: $playlistNames');

                return ListView.builder(
                  itemCount: playlistNames.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        playlistNames[index],
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        _addSongToPlaylist(context, playlistIDs[index], currentSong);
                      },

                    );
                  },
                );
              },
            ),







          ),
        ],
      ),

    );
  }

  void _createNewPlaylist(BuildContext context, String name) async {
    try {
      CollectionReference userPlaylistsCollection = FirebaseFirestore.instance.collection(userID);

      // Check if the user collection exists, and create it if not
      String playlistID = userPlaylistsCollection.doc().id;
      DocumentSnapshot userDoc = await userPlaylistsCollection.doc(userID).get();
      if (!userDoc.exists) {
        print('User collection does not exist. Creating new collection...');
        await userPlaylistsCollection.doc(playlistID).set(<String, dynamic>{
          // Add initial data if needed
        });
        print('User collection created successfully.');
      }

      // Generate a unique ID for the playlist


      // Create a document with the unique ID
      await userPlaylistsCollection.doc(playlistID).set({
        'PlaylistName': name,
        'createdAt': FieldValue.serverTimestamp(), // Add creation timestamp
      });

      // Add the current song to the 'songs' collection inside the playlist document
      await userPlaylistsCollection.doc(playlistID).collection('songs').add({
        'songTitle': currentSong.title.toString(),
        'artist': currentSong.artist,
        'id': currentSong.id,
        'album': currentSong.album,
        'genre': currentSong.genre,
        'source': currentSong.source,
        'image': currentSong.image,
        'trackNumber': currentSong.trackNumber,
        'totalTrackCount': currentSong.totalTrackCount,
        'duration': currentSong.duration,
        'site': currentSong.site,
        'createdAt': FieldValue.serverTimestamp(), // Add creation timestamp for the song
      });


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
  void _addSongToPlaylist(BuildContext context, String playlistID, MusicDataResponse currentSong) async {
    try {
      CollectionReference userPlaylistsCollection = FirebaseFirestore.instance.collection(userID);

      // Check if the song already exists in the playlist
      QuerySnapshot songQuery = await userPlaylistsCollection.doc(playlistID)
          .collection('songs')
          .where('songTitle', isEqualTo: currentSong.title.toString())
          .get();

      if (songQuery.docs.isNotEmpty) {
        // Song already exists in the playlist, show a message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Song already exists in the playlist!'),
          ),
        );
      } else {
        // Add the current song to the 'songs' collection inside the playlist document
        await userPlaylistsCollection.doc(playlistID).collection('songs').add({
          'songTitle': currentSong.title.toString(),
          'artist': currentSong.artist,
          'id': currentSong.id,
          'album': currentSong.album,
          'genre': currentSong.genre,
          'source': currentSong.source,
          'image': currentSong.image,
          'trackNumber': currentSong.trackNumber,
          'totalTrackCount': currentSong.totalTrackCount,
          'duration': currentSong.duration,
          'site': currentSong.site,
          'createdAt': FieldValue.serverTimestamp(), // Add creation timestamp for the song
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Song added to playlist successfully!'),
          ),
        );
      }
    } catch (e) {
      print('Error adding song to playlist: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding song to playlist: $e'),
        ),
      );
    }
  }








}
