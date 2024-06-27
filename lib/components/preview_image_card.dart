import 'dart:io';

import 'package:flutter/material.dart';
class PreviewImageCard extends StatelessWidget {
  final Function onDeleteClicked;
  final String imagePath;

  const PreviewImageCard({super.key, required this.onDeleteClicked, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Stack(
    children: <Widget>[
        AspectRatio(aspectRatio: 1, child: Image.file(File(imagePath), fit: BoxFit.cover),),
        Container(
          alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: onDeleteClicked(),
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.grey.shade200.withOpacity(0.9)),
                    width: 40,
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset('assets/icons/ic_close.png'),
                    )),
                ),
              ),
            ),    ],
);
  }
}