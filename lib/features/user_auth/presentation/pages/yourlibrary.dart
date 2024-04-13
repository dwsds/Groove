import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:debug_it/features/user_auth/presentation/pages/playlistsdetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:debug_it/features/user_auth/models/MusicDataResponse.dart';

class YourLibrary extends StatelessWidget {
  final User user;

  const YourLibrary({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 20), // Add spacing between the button and text
          Text(
            'Your Playlists',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10), // Add spacing before the playlist content
          Expanded(
            child: FutureBuilder<QuerySnapshot>(

              future: FirebaseFirestore.instance.collection(user.uid).get(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                final UserId = user.uid;
                if (snapshot.hasError) {
                  return Text('Error fetching playlists: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No playlists found for user $UserId');
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlaylistDetailsPage(
                              userID: UserId,
                              playlistID: playlistIDs[index],
                            ),
                          ),
                        );
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
}
