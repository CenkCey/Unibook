import 'dart:io';

import 'package:flutter/material.dart';
import 'package:unibook/components/btn_file_picker.dart';
import 'package:unibook/components/btn_image_picker.dart';
import 'package:unibook/components/btn_post.dart';
import 'package:unibook/components/btn_video_picker.dart';
import 'package:unibook/components/post_video_container.dart';

class SendPostCard extends StatefulWidget {
  final String message;
  final String? imageUrl, videoUrl, fileUrl;
  final Function onSendClicked;
  final TextEditingController messageTextController;
  final Function(String?) onImagePicked, onVideoPicked, onFileClicked;

  const SendPostCard(
      {super.key,
      required this.message,
      required this.onSendClicked,
      required this.messageTextController,
      required this.onImagePicked,
      required this.onVideoPicked,
      required this.onFileClicked,
      this.imageUrl,
      this.videoUrl,
      this.fileUrl});

  @override
  State<SendPostCard> createState() => _SendPostCardState();
}

class _SendPostCardState extends State<SendPostCard> {
  String? pickedImageUrl;
  String? pickedVideoUrl;

  void setImageUrl(String? imageUrl) {
    setState(() {
      pickedImageUrl = imageUrl;
      pickedVideoUrl = null;
    });
  }

  void setVideoUrl(String? videoUrl) {
    setState(() {
      pickedImageUrl = null;
      pickedVideoUrl = videoUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(children: <Widget>[
          MessageTextField(
            controller: widget.messageTextController,
            hintText: "Yaz gitsin",
            obscureText: false,
          ),
          (pickedImageUrl != null)
              ? Stack(children: <Widget>[
                  Image.file(File(pickedImageUrl!), fit: BoxFit.cover),
                  Container(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => setImageUrl(null),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.grey.shade200.withOpacity(0.9)),
                            width: 40,
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset('assets/icons/ic_close.png'),
                            )),
                      ),
                    ),
                  ),
                ])
              : (pickedVideoUrl != null)
                  ? Stack(children: <Widget>[
                      PostVideoContainer(videoPath: pickedVideoUrl),
                      Container(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () => setVideoUrl(null),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color:
                                        Colors.grey.shade200.withOpacity(0.9)),
                                width: 40,
                                height: 40,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child:
                                      Image.asset('assets/icons/ic_close.png'),
                                )),
                          ),
                        ),
                      ),
                    ])
                  : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MediaControlsField(
                  onFileClicked: widget.onFileClicked,
                  onImagePicked: (url) {
                    setImageUrl(url);
                    widget.onImagePicked(url);
                  },
                  onVideoPicked: (url) {
                    setVideoUrl(url);
                    widget.onVideoPicked(url);
                  }),
              PostButton(
                  onClicked: () => {
                        if (widget.messageTextController.text.isNotEmpty ||
                            (pickedImageUrl != null &&
                                pickedImageUrl!.isNotEmpty) ||
                            (pickedVideoUrl != null &&
                                pickedVideoUrl!.isNotEmpty))
                          {
                            setImageUrl(null),
                            setVideoUrl(null),
                            FocusScope.of(context).requestFocus(FocusNode()),
                            widget.onSendClicked()
                          }
                      },
                  btnText: "Gönder"),
            ],
          ),
        ]),
      ),
    );
  }
}

class MessageTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MessageTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade200)),
      ),
    );
  }
}

class MediaControlsField extends StatelessWidget {
  final Function(String?) onImagePicked, onVideoPicked, onFileClicked;

  const MediaControlsField(
      {super.key,
      required this.onImagePicked,
      required this.onVideoPicked,
      required this.onFileClicked});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(left: 0, right: 16),
                child: BtnImagePicker(onImagePicked: onImagePicked)),
            Padding(
                padding: const EdgeInsets.only(left: 0, right: 16),
                child: BtnVideoPicker(onVideoPicked: onVideoPicked)),
            Padding(
                padding: const EdgeInsets.only(left: 0, right: 16),
                child: BtnFilePicker(onFilePicked: onFileClicked)),
          ],
        ),
      ),
    );
  }
}
