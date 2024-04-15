import 'package:debug_it/features/user_auth/models/MusicDataResponse.dart';
import 'package:debug_it/features/user_auth/presentation/pages/MusicDetailPage.dart';
import 'package:debug_it/features/user_auth/services/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlaylistDetailsPage extends StatelessWidget {
  final String userID;
  final String playlistID;

  const PlaylistDetailsPage({
    Key? key,
    required this.userID,
    required this.playlistID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Playlist Songs',style: TextStyle(color: Colors.deepPurple.shade300),),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection(userID)
            .doc(playlistID)
            .collection('songs')
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error fetching songs: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text('No songs found in this playlist');
          }

          List<String> songNames = [];
          List<String> songIds = [];

          snapshot.data!.docs.forEach((doc) {
            final data = doc.data() as Map<String, dynamic>;
            if (data.containsKey('songTitle')) {
              songNames.add(data['songTitle']);
            }
            if (data.containsKey('id')) {
              songIds.add(data['id']);
            }
          });
  SizedBox(height: 20,);
          return ListView.builder(
            itemCount: songNames.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  songNames[index],
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  if (index >= 0 && index < songIds.length) {
                    try {
                      // Fetch the song details by ID
                      MusicDataResponse? song = await ApiService().getSongById(songIds[index]);
                      if (song != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MusicDetailPage(response: song),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Song details not found.'),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error fetching song details: $e'),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Invalid song index.'),
                      ),
                    );
                  }
                },
              );
            },
          );



        },
      ),
    );
  }
}
