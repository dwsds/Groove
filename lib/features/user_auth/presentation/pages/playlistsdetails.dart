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
      appBar: AppBar(
        title: Text('Playlist Details'),
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
          snapshot.data!.docs.forEach((doc) {
            final data = doc.data() as Map<String, dynamic>;
            if (data.containsKey('songTitle')) {
              songNames.add(data['songTitle']);
            }
          });

          return ListView.builder(
            itemCount: songNames.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  songNames[index],
                  style: TextStyle(color: Colors.black),
                ),
                // Add onTap action if needed
              );
            },
          );
        },
      ),
    );
  }
}
