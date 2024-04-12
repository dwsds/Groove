import 'package:flutter/material.dart';
import 'package:debug_it/features/user_auth/models/category.dart';
import 'package:debug_it/features/user_auth/models/music.dart';
import 'package:debug_it/features/user_auth/services/category_operations.dart';
import 'package:debug_it/features/user_auth/services/music_operations.dart';

class Home extends StatelessWidget {
  Function _miniPlayer;
  Home(this._miniPlayer); // Dart Constructor ShortHand
  // const Home({Key? key}) : super(key: key);
  Widget createCategory(Category category) {
    return Container(
        color: Colors.blueGrey.shade400,
        child: Row(
          children: [
            Image.network(category.imageURL, fit: BoxFit.cover),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                category.name,
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ));
  }

  List<Widget> createListOfCategories() {
    List<Category> categoryList =
    CategoryOperations.getCategories(); // Rec Data
    // Convert Data to Widget Using map function
    List<Widget> categories = categoryList
        .map((Category category) => createCategory(category))
        .toList();
    return categories;
  }

  Widget createMusic(Music music) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: 200,
            child: InkWell(
              onTap: () {
                _miniPlayer(music, stop: true);
              },
              child: Image.network(
                music.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            music.name,
            style: TextStyle(color: Colors.white),
          ),
          Text(music.desc, style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }

  Widget createMusicList(String label) {
    List<Music> musicList = MusicOperations.getMusic();
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 300,
            child: ListView.builder(
              //padding: EdgeInsets.all(5),
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                return createMusic(musicList[index]);
              },
              itemCount: musicList.length,
            ),
          )
        ],
      ),
    );
  }

  Widget createGrid() {
    return Container(
      padding: EdgeInsets.all(10),
      height: 280,
      child: GridView.count(
        childAspectRatio: 5 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: createListOfCategories(),
        crossAxisCount: 2,
      ),
    );
  }

  Widget createAppBar(String message) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Text(message),
      actions: [
        Padding(
            padding: EdgeInsets.only(right: 10), child: Icon(Icons.settings))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
          child: Container(
            child: Column(
              children: [
                createAppBar('Good morning'),
                SizedBox(
                  height: 5,
                ),
                createGrid(),
                createMusicList('Made for you'),
                createMusicList('Popular PlayList')
              ],
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.blueGrey.shade300, Colors.black],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.1, 0.3])),
            //child: Text('Hello Flutter'),
            //color: Colors.orange,
          )),
    );
  }
}
