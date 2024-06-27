import 'package:intl/intl.dart';
import 'package:unibook/model/user_model.dart';

class PostModel {
  final String id, message; 
  final String? imageURL, videoUrl, fileUrl;
  final DateTime postTime;
  final UserModel author;

  const PostModel(this.imageURL, this.videoUrl, this.fileUrl, {
    required this.id,
    required this.message,
    required this.author,
    required this.postTime,
  });

  String get postTimeFormatted => DateFormat.yMMMMEEEEd().format(postTime);
}