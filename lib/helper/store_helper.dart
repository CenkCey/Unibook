import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttery_timber/fluttery_timber.dart';
import 'package:unibook/helper/shared_pref_helper.dart';
import 'package:unibook/model/post_request_model.dart';
import 'package:unibook/model/user_model.dart';

class FireStoreHelper {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<bool> uploadPosts(PostRequestModel postRequestModel) async {
    final userPost = <String, dynamic>{
      "mailAddress": postRequestModel.mailAddress,
      "message": postRequestModel.message,
      "imageUrl": postRequestModel.imagePath,
      "videoUrl": postRequestModel.videoPath,
      "fileUrl": postRequestModel.filePath,
      "time": DateTime.now().millisecondsSinceEpoch
    };

    try {
      await db.collection("user_posts").add(userPost);
      return true;
    } on FirebaseException {
      return false;
    }
  }

  Future<bool> uploadUser(UserModel userModel) async {
    final user = <String, dynamic>{
      "uuid": userModel.id,
      "mailAddress": userModel.email,
      "name": userModel.name,
      "imageUrl": userModel.image,
      "type": userModel.type
    };

    try {
      var doc = await db.collection("users").add(user);
      await SharedPrefHelper.setEmail(userModel.email);
      await SharedPrefHelper.setUserName(userModel.name);
      await SharedPrefHelper.setUserImageUrl(userModel.image);
      await SharedPrefHelper.setDocId(doc.id);
      await SharedPrefHelper.setUserType(userModel.type);
      return true;
    } on FirebaseException {
      return false;
    }
  }

  Future<void> updateUserImage(String imageUrl) async {
    try {
      var docId = await SharedPrefHelper.getDocId();
      await db.collection("users").doc(docId).update({'imageUrl': imageUrl});
    } on FirebaseException {}
  }

  Future<UserModel?> getUser(String mailAddress) async {
    String name = "", imageUrl = "", id = "", docId = "";
    int type = 0;
    try {
      await db
          .collection("users")
          .where("mailAddress", isEqualTo: mailAddress)
          .get()
          .then((data) {
        if (data.docs.isNotEmpty && data.docs.first.exists) {
          final myself = data.docs.first;
          docId = myself.id;
          myself.data().forEach((key, value) {
            if (key == "imageUrl") {
              imageUrl = value;
            } else if (key == "name") {
              name = value;
            } else if (key == "uuid") {
              id = value;
            } else if (key == "type") {
              type = value;
            }
          });
        }
      }, onError: (e) => Timber.e("Error completing: $e"));
      // ignore: empty_catches
    } on FirebaseException {}
    return UserModel(
        id: id,
        name: name,
        email: mailAddress,
        image: imageUrl,
        type: type,
        docId: docId);
  }

  Future<void> deletePost(String documentId) async {
    try {
      await db.collection("user_posts").doc(documentId).delete();
    } on FirebaseException catch (e) {
      Timber.e(e.message ?? "");
    }
  }
}
