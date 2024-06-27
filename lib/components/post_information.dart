import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:unibook/components/post_user_info.dart';
import 'package:unibook/components/post_video_container.dart';
import 'package:unibook/helper/shared_pref_helper.dart';

class UserInformation extends StatefulWidget {
  final Function(String) onDeleteClicked;
  const UserInformation({super.key, required this.onDeleteClicked});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final Stream<QuerySnapshot> _postsStream = FirebaseFirestore.instance
      .collection('user_posts')
      .orderBy('time', descending: true)
      .snapshots();
  String _myMailAddress = "";

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    final prefMail = await SharedPrefHelper.getEmail();
    setState(() {
      if (prefMail != null && prefMail.isNotEmpty) {
        _myMailAddress = prefMail;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _postsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            value: null,
            color: Colors.black87,
            strokeWidth: 1,
            semanticsLabel: 'Circular progress indicator',
          );
        }

        return ListView(
          shrinkWrap: true,
          primary: false,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            String message = "";
            String? imageUrl = "";
            String? videoUrl = "";
            String mailAddress = "";
            int time = 0;
            String documentId = document.id;
            if (data.containsKey("message")) {
              message = data['message'];
            }
            if (data.containsKey("mailAddress")) {
              mailAddress = data['mailAddress'];
            }
            if (data.containsKey("imageUrl")) {
              imageUrl = data['imageUrl'];
            }
            if (data.containsKey("time")) {
              time = data['time'];
            }
            if (data.containsKey("videoUrl")) {
              videoUrl = data['videoUrl'];
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shadowColor: Colors.black38,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Column(children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16)),
                        color: Colors.grey.shade50),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          GetUserName(mailAddress, time),
                          (_myMailAddress == mailAddress)
                              ? Expanded(
                                  child: PopupMenuButton<String>(
                                    onSelected: (String item) {
                                      widget.onDeleteClicked(documentId);
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                          value: "Sil", child: Text('Sil')),
                                    ],
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: (message.isNotEmpty) ? true : false,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            message,
                            textAlign: TextAlign.left,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  (imageUrl != null && imageUrl.isNotEmpty)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16)),
                                  child: Image.network(
                                    imageUrl,
                                    height: 300,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : (videoUrl != null && videoUrl.isNotEmpty)
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16)),
                                      child: PostVideoContainer(
                                          videoUrl: videoUrl),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container()
                ]),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  String getFormattedDate(int time) {
    var dt = DateTime.fromMillisecondsSinceEpoch(time);
    return DateFormat.yMMMMEEEEd().format(dt);
  }
}
