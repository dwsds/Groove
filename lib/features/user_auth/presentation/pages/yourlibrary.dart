import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:debug_it/features/user_auth/presentation/pages/playlistsdetails.dart';
import 'package:firebase_auth/firebase_auth.dart';

class YourLibrary extends StatelessWidget {
  final User user;

  const YourLibrary({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Column(
        children: [
          SizedBox(height: 60),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 31, vertical: 6),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/local");
              },
              child: Row(
                children: [
                  Icon(Icons.folder, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    "Your Local Music",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          Text(
            'Your Playlists',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.white),
          ),
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
                return ListView.builder(
                  itemCount: playlistNames.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        playlistNames[index],
                        style: TextStyle(color: Colors.grey.shade200),
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
