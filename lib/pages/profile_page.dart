import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttery_timber/timber.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unibook/helper/shared_pref_helper.dart';
import 'package:unibook/helper/storage_helper.dart';
import 'package:unibook/helper/store_helper.dart';
import 'package:unibook/model/appbar_widget.dart';
import 'package:unibook/model/numbers_widget.dart';
import 'package:unibook/model/profile_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = "İsim", _mailAddress = "Mail adres", _userImageUrl = "";

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    final prefName = await SharedPrefHelper.getUsername();
    final prefMail = await SharedPrefHelper.getEmail();
    final prefImage = await SharedPrefHelper.getUserImageUrl();
    setState(() {
      if (prefName != null && prefName.isNotEmpty) {
        _username = prefName;
      }
      if (prefMail != null && prefMail.isNotEmpty) {
        _mailAddress = prefMail;
      }
      if (prefImage != null && prefImage.isNotEmpty) {
        _userImageUrl = prefImage;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: _userImageUrl,
            onClicked: () => pickImage(context),
          ),
          const SizedBox(height: 24),
          buildName(),
          const SizedBox(height: 24),
          NumbersWidget(),
        ],
      ),
    );
  }

  Widget buildName() => Column(
        children: [
          Text(
            _username,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            _mailAddress,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Future<void> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    String? imagePath;
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
                await picker.pickImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              final String? mime = lookupMimeType(pickedFile.path);
              if (mime == null || mime.startsWith('image/')) {
                imagePath = pickedFile.path;
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
          if (mime == null || mime.startsWith('image/')) {
            imagePath = pickedFile.path;
          }
        }
      }
      if (imagePath != null && imagePath.isNotEmpty) {
        if (context.mounted) {
          showDialog(
              context: context,
              builder: (context) {
                return const Center(child: CircularProgressIndicator());
              });
        }

        var url = await StorageHelper().uploadFile(File(imagePath));
        if (url != null && url.isNotEmpty) {
          SharedPrefHelper.setUserImageUrl(url);
          await FireStoreHelper().updateUserImage(url);
          _loadPreferences();
        }
        if (context.mounted) {
          Navigator.pop(context);
        }
      }
    } on Exception catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
      }
      Timber.e("BtnImagePicker", error: e);
    }
  }
}
