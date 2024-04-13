import 'dart:io';
import 'dart:async'; // Add this import for async/await support
import 'package:flutter/widgets.dart'; // Add this import for Key and StatefulWidget
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:debug_it/features/user_auth/models/stream.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class StreamController extends GetxController {
  RxList<Stream> streams = <Stream>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStreams();
  }

  Future<bool> _requestPermission(Permission permission) async {
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
    if (build.version.sdkInt >= 30) {
      var re = await Permission.manageExternalStorage.request();
      if (re.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      if (await permission.isGranted) {
        return true;
      } else {
        var result = await permission.request();
        if (result.isGranted) {
          return true;
        } else {
          return false;
        }
      }
    }
  }

  void fetchStreams() async {
    List<Stream> serverResponse = [];
    List<FileSystemEntity> songs = [];

    if (await _requestPermission(Permission.storage)) {
      // Update the directory path to point to the 'Download' directory on your device
      Directory directory = Directory('/storage/emulated/0/Download/');
      if (await directory.exists()) {
        List<FileSystemEntity> files =
        directory.listSync(recursive: true, followLinks: false);
        for (FileSystemEntity entity in files) {
          if (entity.path.endsWith('.mp3')) {
            songs.add(entity);
            Metadata metadata = await MetadataRetriever.fromFile(File(entity.path));
            serverResponse.add(
              Stream(
                musicPath: metadata.filePath,
                picture: metadata.albumArt,
                title: metadata.trackName,
                long: metadata.trackDuration.toString(),
              ),

            );
          }
        }
      } else {
        print('Download directory not found.');
      }
    } else {
      print('Storage permission denied.');
    }

    streams.value = serverResponse;
  }
}
