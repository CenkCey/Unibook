import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttery_timber/fluttery_timber.dart';
import 'package:unibook/components/post_card.dart';
import 'package:unibook/components/post_information.dart';
import 'package:unibook/components/send_post_card.dart';
import 'package:unibook/dialogs/exit_popup.dart';
import 'package:unibook/helper/shared_pref_helper.dart';
import 'package:unibook/helper/storage_helper.dart';
import 'package:unibook/helper/store_helper.dart';
import 'package:unibook/model/post_request_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController messageTextController = TextEditingController();
  ScrollController scrollController = ScrollController();
  String selectedPage = '';
  String _username = "İsim", _mailAddress = "Mail adres", _userImageUrl = "";
  int _userType = 0;

  String? imagePath, videoPath;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    final prefName = await SharedPrefHelper.getUsername();
    final prefMail = await SharedPrefHelper.getEmail();
    final prefImage = await SharedPrefHelper.getUserImageUrl();
    final prefUserType = await SharedPrefHelper.getUserType();
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
      if (prefUserType != null) {
        _userType = prefUserType;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        backgroundColor: Colors.grey.shade200,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
                onTap: () {
                  logout(context);
                },
                child: const Icon(Icons.logout_outlined)),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(10, 10, 10, 80),
        tooltip: 'Increment',
        onPressed: scrollTop,
        child: const Icon(Icons.arrow_upward_outlined,
            color: Colors.white, size: 28),
      ),
      drawer: Drawer(
        child: NotificationListener(
          onNotification: (scrollNotification) {
            Timber.i(scrollController.position.pixels.toString());
            return true;
          },
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(_username),
                accountEmail: Text(_mailAddress),
                decoration: const BoxDecoration(color: Colors.grey),
                currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: (_userImageUrl.isNotEmpty)
                        ? NetworkImage(
                            _userImageUrl,
                          )
                        : const AssetImage(
                            "assets/images/img_empty_profile.png")),
              ),
              ListTile(
                leading: const Icon(Icons.message),
                title: const Text('Messages'),
                onTap: () {
                  setState(() {
                    selectedPage = 'Messages';
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/profile');
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  setState(() {
                    selectedPage = 'Settings';
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            (_userType > 0)
                ? SendPostCard(
                    message: "Yaz bir şeyler",
                    onSendClicked: onSendClicked,
                    messageTextController: messageTextController,
                    onImagePicked: onImagePicked,
                    onVideoPicked: onVideoPicked,
                    onFileClicked: onFileClicked)
                : Container(),
            UserInformation(onDeleteClicked: onDeletePostClicked)
          ],
        ),
      ),
    );
  }

  Future<void> onSendClicked() async {
    BuildContext? dialogContext;
    showDialog(
        context: context,
        builder: (ctx) {
          dialogContext = ctx;
          return const Center(child: CircularProgressIndicator());
        });

    var storeRequest = PostRequestModel(null, null, null, _userImageUrl,
        message: messageTextController.text,
        mailAddress: _mailAddress,
        userName: _username);
    messageTextController.clear();
    if (imagePath != null) {
      var postImageUrl = await StorageHelper().uploadFile(File(imagePath!));
      storeRequest.imagePath = postImageUrl;
    } else if (videoPath != null) {
      var postVideoUrl = await StorageHelper().uploadFile(File(videoPath!));
      storeRequest.videoPath = postVideoUrl;
    }

    await FireStoreHelper().uploadPosts(storeRequest);
    if (dialogContext != null && dialogContext!.mounted) {
      Navigator.pop(dialogContext!);
    }
  }

  void onImagePicked(String? imagePath) {
    this.imagePath = imagePath;
    videoPath = null;
  }

  void onVideoPicked(String? videoPath) {
    this.videoPath = videoPath;
    imagePath = null;
  }

  Future<void> onDeletePostClicked(String documentId) async {
    BuildContext? dialogContext;
    showDialog(
        context: context,
        builder: (ctx) {
          dialogContext = ctx;
          return const Center(child: CircularProgressIndicator());
        });
    await FireStoreHelper().deletePost(documentId);
    if (dialogContext != null && dialogContext!.mounted) {
      Navigator.pop(dialogContext!);
    }
  }

  void onFileClicked(String? imagePath) {}

  void scrollTop() {
    setState(() {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 500),
      );
    });
  }

  void logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/auth');
      }
    } on FirebaseAuthException catch (e) {
      Timber.e(e.message ?? "");
    }
  }
}
