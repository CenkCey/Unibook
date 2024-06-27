class PostRequestModel{

    final String message, mailAddress, userName;
    String? imagePath, videoPath, filePath;
    final String userImageUrl;

    PostRequestModel(this.imagePath, this.videoPath, this.filePath, this.userImageUrl, {
      required this.message,
      required this.mailAddress,
      required this.userName
    });
}