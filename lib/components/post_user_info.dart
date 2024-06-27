import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GetUserName extends StatelessWidget {
  final String mailAddress;
  final int time;
  const GetUserName(this.mailAddress, this.time,
      {super.key});

  String get postTimeFormatted => DateFormat.yMMMMd()
      .add_Hm()
      .format(DateTime.fromMillisecondsSinceEpoch(time));

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<QuerySnapshot>(
      future: users.limit(1).where("mailAddress", isEqualTo: mailAddress).get(),
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

        String userImageUrl = "";
        String userName = "";
        if (snapshot.connectionState == ConnectionState.done) {
          var data = snapshot.data;
          if (data != null) {
            if (data.docs.isNotEmpty && data.docs.first.exists) {
              final myself = data.docs.first;
              var myData = myself.data();
              if (myData != null && myData is Map<String, dynamic>) {
                myData.forEach((key, value) {
                  if (key == "imageUrl") {
                    userImageUrl = value;
                  } else if (key == "name") {
                    userName = value;
                  }
                });
              }
            }
          }
          return Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: (userImageUrl.isNotEmpty)
                    ? NetworkImage(userImageUrl)
                    : const AssetImage("assets/images/img_empty_profile.png"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  userName,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  postTimeFormatted,
                  textAlign: TextAlign.end,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ),
            ],
          );
        }

        return const Text("loading");
      },
    );
  }
}
