// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
//
// class HomePage extends StatelessWidget {
//   const HomePage({Key? key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         toolbarHeight: 30,
//         leading: Builder(
//           builder: (context) => IconButton(
//             icon: Icon(Icons.menu), // Menu icon
//             onPressed: () {
//               Scaffold.of(context).openDrawer(); // Open the menu from left to right
//             },
//           ),
//         ),
//       ),
//       backgroundColor: Colors.grey.shade900, // Dark grey background for body
//
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Text(
//             //   "Welcome to Home Page!",
//             //   style: TextStyle(fontSize: 50, color: Colors.white), // White text color
//             // ),
//           ],
//         ),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.black,
//               ),
//               child: Text(
//                 'Menu',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             ListTile(
//               title: Text(
//                 'Delete Your Account',
//                 style: TextStyle(color: Colors.black),
//               ),
//               onTap: () {
//                 Navigator.pushNamed(context, "/delete");
//               },
//             ),
//             ListTile(
//               title: Text(
//                 'Logout',
//                 style: TextStyle(color: Colors.black),
//               ),
//               onTap: () {
//                 FirebaseAuth.instance.signOut();
//                 Navigator.pushNamed(context, "/login");
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// import 'dart:typed_data';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:debug_it/features/user_auth/controllers/player_controller.dart';
// import 'package:sizer/sizer.dart';
// import 'package:debug_it/features/user_auth/controllers/duration_extension.dart';
//
// class HomePage extends StatelessWidget {
//   HomePage({Key? key}) : super(key: key);
//   final PlayerController playerController = Get.put(PlayerController());
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: const Color(0xFFFBFFFF),
//         appBar: AppBar(
//           backgroundColor: const Color(0xFF7AC9FF),
//           title: const Center(
//             child: Text(
//               'Music Player',
//               style: TextStyle(
//                 color: Color(0xFFFBFFFF),
//               ),
//             ),
//           ),
//         ),
//         body: Padding(
//           padding: EdgeInsets.only(
//             top: 5.h,
//             left: 16.sp,
//             bottom: 10.sp,
//             right: 16.sp,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Flexible(
//                 child: Obx(
//                       () => ListView.builder(
//                     itemCount: playerController.streams.length,
//                     physics: const BouncingScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: EdgeInsets.symmetric(vertical: 8.sp),
//                         child: InkWell(
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(10.sp),
//                           ),
//                           onTap: () async {
//                             await playerController.stop();
//                             playerController.currentStreamIndex.value = index;
//                             await playerController.play();
//                           },
//                           child: Obx(
//                                 () => Container(
//                               height: 52.sp,
//                               decoration: BoxDecoration(
//                                 color: (playerController.currentStreamIndex.value == index)
//                                     ? const Color(0xFF7AC9FF)
//                                     : Colors.transparent,
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(10.sp),
//                                 ),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Padding(
//                                     padding:
//                                     EdgeInsets.symmetric(horizontal: 13.sp),
//                                     child: SizedBox(
//                                       height: 35.sp,
//                                       width: 35.sp,
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(15.sp)),
//                                         child: playerController.streams[index].picture != null ?
//                                         Image.memory(
//                                           playerController.streams[index].picture ?? Uint8List(0),
//                                         ) :
//                                         Container(
//                                           color: const Color(0xFFB2D3DA),
//                                           child: const Center(
//                                             child: Text("404"),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Column(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.center,
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           mainAxisSize: MainAxisSize.max,
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Expanded(
//                                               child: Text(
//                                                 playerController
//                                                     .streams[index].title!,
//                                                 style: TextStyle(
//                                                   fontSize: 14.sp,
//                                                   overflow: TextOverflow.ellipsis,
//                                                   color: (playerController.currentStreamIndex.value == index)
//                                                       ? const Color(0xFFFBFFFF)
//                                                       : const Color(0xFF7AC9FF),
//                                                   fontWeight: FontWeight.w400,
//                                                   fontFamily: "Segoe UI",
//                                                 ),
//                                               ),
//                                             ),
//                                             Padding(
//                                               padding:
//                                               EdgeInsets.only(right: 15.sp),
//                                               child: Text(
//                                                 Duration(
//                                                   milliseconds: int.tryParse(
//                                                       playerController.streams[index].long!.toString()
//                                                   ) ?? 0,
//                                                 ).timeFormat,
//                                                 style: TextStyle(
//                                                   fontSize: 13.sp,
//                                                   color: (playerController.currentStreamIndex.value == index)
//                                                       ? const Color(0xFFFBFFFF)
//                                                       : const Color(0xFF7AC9FF),
//                                                   fontWeight: FontWeight.w300,
//                                                   fontFamily: "Segoe UI",
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               Obx(
//                     () => Column(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(right: 15.sp, left: 15.sp),
//                       child: Row(
//                         children: [
//                           Text(
//                             playerController.position.value.timeFormat,
//                             style: TextStyle(
//                               fontSize: 15.sp,
//                               color: const Color(0xFF7AC9FF),
//                             ),
//                           ),
//                           Expanded(
//                             child: Slider(
//                                 activeColor: const Color(0xFF7AC9FF),
//                                 value: playerController.position.value.inSeconds.toDouble(),
//                                 min: 0.0,
//                                 max: playerController.duration.value.inSeconds.toDouble() + 1.0,
//                                 onChanged: (double value) {
//                                   playerController.setPositionValue = value;
//                                 }),
//                           ),
//                           Text(
//                             playerController.duration.value.timeFormat,
//                             style: TextStyle(
//                               fontSize: 15.sp,
//                               color: const Color(0xFF7AC9FF),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(
//                           right: 30.sp,
//                           left: 30.sp,
//                           top: 5.sp,
//                           bottom: 5.sp),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           GestureDetector(
//                             onTap: () async {
//                               await playerController.stop();
//                               await playerController.back();
//                             },
//                             child: Icon(
//                               Icons.skip_previous,
//                               color: const Color(0xFF7AC9FF),
//                               size: 35.sp,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () async {
//                               await playerController.smartPlay();
//                             },
//                             child: Icon(
//                               (playerController.playState.value == PlayerState.playing)
//                                   ? Icons.pause
//                                   : Icons.play_arrow,
//                               color: const Color(0xFF7AC9FF),
//                               size: 60.sp,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () async {
//                               await playerController.stop();
//                               await playerController.next();
//                             },
//                             child: Icon(
//                               Icons.skip_next,
//                               color: const Color(0xFF7AC9FF),
//                               size: 35.sp,),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Text(
//                       'by Usama Muzaffar',
//                       style: TextStyle(
//                         color: Color(0xFF7AC9FF),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:debug_it/features/user_auth/controllers/player_controller.dart';
// import 'package:sizer/sizer.dart';
import 'package:debug_it/features/user_auth/controllers/duration_extension.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final PlayerController playerController = Get.put(PlayerController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFFFF),
        appBar: AppBar(
          backgroundColor: const Color(0xFF7AC9FF),
          title: const Center(
            child: Text(
              'Music Player',
              style: TextStyle(
                color: Color(0xFFFBFFFF),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(
            top: 5,
            left: 16,
            bottom: 10,
            right: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Obx(
                      () => ListView.builder(
                    itemCount: playerController.streams.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: InkWell(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          onTap: () async {
                            await playerController.stop();
                            playerController.currentStreamIndex.value = index;
                            await playerController.play();
                          },
                          child: Obx(
                                () => Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: (playerController.currentStreamIndex.value == index)
                                    ? const Color(0xFF7AC9FF)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 13),
                                    child: SizedBox(
                                      height: 35,
                                      width: 35,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        child: playerController.streams[index].picture != null ?
                                        Image.memory(
                                          playerController.streams[index].picture ?? Uint8List(0),
                                        ) :
                                        Container(
                                          color: const Color(0xFFB2D3DA),
                                          child: const Center(
                                            child: Text("404"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                playerController
                                                    .streams[index].title!,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  overflow: TextOverflow.ellipsis,
                                                  color: (playerController.currentStreamIndex.value == index)
                                                      ? const Color(0xFFFBFFFF)
                                                      : const Color(0xFF7AC9FF),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Segoe UI",
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              EdgeInsets.only(right: 15),
                                              child: Text(
                                                Duration(
                                                  milliseconds: int.tryParse(
                                                      playerController.streams[index].long!.toString()
                                                  ) ?? 0,
                                                ).timeFormat,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: (playerController.currentStreamIndex.value == index)
                                                      ? const Color(0xFFFBFFFF)
                                                      : const Color(0xFF7AC9FF),
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily: "Segoe UI",
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Obx(
                    () => Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 15, left: 15),
                      child: Row(
                        children: [
                          Text(
                            playerController.position.value.timeFormat,
                            style: TextStyle(
                              fontSize: 15,
                              color: const Color(0xFF7AC9FF),
                            ),
                          ),
                          Expanded(
                            child: Slider(
                                activeColor: const Color(0xFF7AC9FF),
                                value: playerController.position.value.inSeconds.toDouble(),
                                min: 0.0,
                                max: playerController.duration.value.inSeconds.toDouble() + 1.0,
                                onChanged: (double value) {
                                  playerController.setPositionValue = value;
                                }),
                          ),
                          Text(
                            playerController.duration.value.timeFormat,
                            style: TextStyle(
                              fontSize: 15,
                              color: const Color(0xFF7AC9FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: 30,
                          left: 30,
                          top: 5,
                          bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await playerController.stop();
                              await playerController.back();
                            },
                            child: Icon(
                              Icons.skip_previous,
                              color: const Color(0xFF7AC9FF),
                              size: 35,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await playerController.smartPlay();
                            },
                            child: Icon(
                              (playerController.playState.value == PlayerState.playing)
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: const Color(0xFF7AC9FF),
                              size: 60,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await playerController.stop();
                              await playerController.next();
                            },
                            child: Icon(
                              Icons.skip_next,
                              color: const Color(0xFF7AC9FF),
                              size: 35,),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


