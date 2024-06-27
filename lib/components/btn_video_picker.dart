import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttery_timber/fluttery_timber.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BtnVideoPicker extends StatelessWidget {
  final Function(String?) onVideoPicked;
  const BtnVideoPicker({super.key, required this.onVideoPicked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: pickVideo,
        child: Image.asset(
          "assets/icons/ic_video.png",
          height: 28,
          width: 28,
          fit: BoxFit.cover,
        ));
  }

  Future<void> pickVideo() async {
    final ImagePicker picker = ImagePicker();
    String? videoPath;
    try {
      var status = await Permission.camera.status;
      if (status.isDenied && !status.isPermanentlyDenied) {
        var androidPermission = Permission.photos;
        if (Platform.isAndroid) {
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          if (androidInfo.version.sdkInt <= 32) {
            androidPermission = Permission.storage;
          }
          final statusNew = await androidPermission.request();
          if (statusNew.isGranted) {
            final XFile? pickedFile =
                await picker.pickVideo(source: ImageSource.gallery);
            if (pickedFile != null) {
              final String? mime = lookupMimeType(pickedFile.path);
              if (mime == null || mime.startsWith('video/')) {
                videoPath = pickedFile.path;
              }
            }
          } else {
            Fluttertoast.showToast(
                msg: "Fotoğraf izni vermelisiniz!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 14.0);
          }
        }
      } else if (status.isGranted) {
        final XFile? pickedFile =
            await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          final String? mime = lookupMimeType(pickedFile.path);
          if (mime == null || mime.startsWith('video/')) {
            videoPath = pickedFile.path;
          }
        }
      }

      onVideoPicked(videoPath);
    } on Exception catch (e) {
      Timber.e("BtnImagePicker", error: e);
    }
  }
}
