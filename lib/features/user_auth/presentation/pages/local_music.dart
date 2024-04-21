import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:debug_it/features/user_auth/controllers/player_controller.dart';
import 'package:debug_it/features/user_auth/controllers/duration_extension.dart';

class LocalMusic extends StatelessWidget {
  LocalMusic({Key? key}) : super(key: key);
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

                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(15)),

                                          child: SizedBox(
                                            height: 35,
                                            width: 35,
                                            child: Image.asset(
                                              'assets/music_icon.jpg', // Path to your custom music icon in the assets folder
                                              fit: BoxFit.fill,
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
                                                playerController.streams[index].musicPath!.split('/').last,
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


