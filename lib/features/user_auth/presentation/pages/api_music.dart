import 'package:flutter/material.dart';
import 'package:debug_it/features/user_auth/services/ApiService.dart';
import 'package:debug_it/features/user_auth/models/MusicDataResponse.dart';
import 'MusicDetailPage.dart';

class ApiPage extends StatefulWidget {
  const ApiPage({Key? key}) : super(key: key);

  @override
  State<ApiPage> createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  List<MusicDataResponse> musicList = [];
  MusicDataResponse? currentSong;
  bool isPlaying = false; // Track play/pause state

  @override
  void initState() {
    super.initState();
    fetchMusicData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music App"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/local");
              },
              child: Text(
                "Local Music",
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
          ),
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
                // Implement your logout logic here
                Navigator.pushNamed(context, "/login");
              },
            ),
          ],
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
                  padding: const EdgeInsets.only(left: 8, bottom: 8, right: 8, top: 4),
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
                    Text(
                      musicList[index].title.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      musicList[index].artist.toString(),
                      style: TextStyle(color: Colors.grey, fontSize: 12),
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
}
