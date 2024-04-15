import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debug_it/features/user_auth/presentation/widgets/inherited_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:debug_it/features/user_auth/services/ApiService.dart';
import 'package:debug_it/features/user_auth/models/MusicDataResponse.dart';
import 'MusicDetailPage.dart';
import 'selectPlaylist.dart';

class ApiPage extends StatefulWidget {
  final User user;
  const ApiPage({Key? key, required this.user}) : super(key: key);

  @override
  State<ApiPage> createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  List<MusicDataResponse> musicList = [];
  late MusicDataResponse currentSong = MusicDataResponse(
    id: '',
    title: '',
    album: '',
    artist: '',
    genre: '',
    source: '',
    image: '',
    trackNumber: 0,
    totalTrackCount: 0,
    duration: 0,
    site: '',
  );

  bool isPlaying = false;
  @override
  void initState() {
    super.initState();
    fetchMusicData();
  }
  @override
  Widget build(BuildContext context) {
    return MusicDataWidget(
      user: widget.user,
      currentSong: currentSong,
      createNewPlaylist: _createNewPlaylist,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          toolbarHeight:50,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),color: Colors.white,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),

        body: Column(
          children: [
            Expanded(
              child: customListCard(),
            ),
            if (currentSong != null) _buildBottomBar(),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Delete Your Account',
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/delete");
                },
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  Navigator.pushNamed(context, "/login");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchMusicData() async {
    final musiclist = await ApiService().getAllFetchMusicData();
    setState(() {
      musicList = musiclist;
    });
  }

  Widget customListCard() {
    return Builder(
      builder: (BuildContext context) {
        return ListView.builder(

          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  currentSong = musicList[index];
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MusicDetailPage(response: musicList[index]),
                  ),
                );
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6, bottom: 8, right: 8, top: 10),
                      child: SizedBox(
                        child: FadeInImage.assetNetwork(
                          height: 60,
                          width: 60,
                          placeholder: "assets/music_icon.jpg",
                          image: musicList[index].image.toString(),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,                          children: [
                            Expanded(
                              child: Text(
                                musicList[index].title.toString(),
                                style: TextStyle(color: Colors.white, fontSize: 18),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            PopupMenuButton(
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem(
                                  child: Text("Add to Playlist"),
                                  value: musicList[index],
                                ),
                              ],
                              onSelected: (value) {
                                if (value is MusicDataResponse && widget.user != null && widget.user.uid != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreateNewPlaylistPage(
                                        userID: widget.user.uid!,
                                        currentSong: value,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          musicList[index].artist.toString(),
                          style: TextStyle(color: Colors.deepPurple.shade200, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
          itemCount: musicList.length,
        );
      },
    );
  }

  Widget _buildBottomBar() {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            currentSong?.title ?? '',
            style: TextStyle(color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isPlaying = !isPlaying; // Toggle play/pause state
              });
            },
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _createNewPlaylist(String playlistName) async {
    try {
      CollectionReference playlistsCollection =
      FirebaseFirestore.instance.collection('playlists');

      DocumentSnapshot playlistDoc =
      await playlistsCollection.doc(widget.user.uid).get();

      if (!playlistDoc.exists) {
        await playlistsCollection.doc(widget.user.uid).set({});
      }

      await playlistsCollection
          .doc(widget.user.uid)
          .collection(playlistName)
          .doc(DateTime.now().toString())
          .set({
        'songName': currentSong.title.toString(),
        'artist': currentSong.artist,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New playlist created successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating playlist: $e'),
        ),
      );
    }
  }
}