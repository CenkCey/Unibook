import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageHelper {
  final storageRef =
      FirebaseStorage.instanceFor(bucket: "gs://unibook-95eb6.appspot.com")
          .ref();

  Future<String?> uploadFile(File? imageFile) async {
    var suffix = DateTime.now().millisecondsSinceEpoch;
    final imagesRef = storageRef.child("images/$suffix.jpg");
    if(imageFile == null) return null;
    try {
      await imagesRef.putFile(imageFile);
      return await imagesRef.getDownloadURL();
    } on FirebaseException {
      return null;
    }
  }
}
