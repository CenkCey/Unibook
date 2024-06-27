import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String userName;
  final String message;
  final String date;
  final String? imageUrl, videoUrl, fileUrl;
  final String? userImage;

  const PostCard(
      {super.key,
      required this.userName,
      required this.message,
      required this.date,
      this.imageUrl,
      this.videoUrl,
      this.fileUrl,
      this.userImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black87,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                color: Colors.grey.shade200),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: (userImage != null && userImage!.isEmpty)
                        ? NetworkImage(userImage!)
                        : const AssetImage("assets/images/img_empty_profile.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(userName),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(message),
          ),
          Visibility(
            visible: (imageUrl != null && imageUrl!.isNotEmpty) ? true : false,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16)),
                    child: Expanded(
                      flex: 1,
                      child: Image.network(
                        imageUrl ?? "",
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
