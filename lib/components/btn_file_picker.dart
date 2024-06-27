import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BtnFilePicker extends StatelessWidget {
  final Function(String?) onFilePicked;
  const BtnFilePicker({super.key, required this.onFilePicked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: pickFile,
        child: Image.asset(
          "assets/icons/ic_file.png",
          height: 28,
          width: 28,
          fit: BoxFit.cover,
        ));
  }

  Future<void> pickFile() async {
      Fluttertoast.showToast(msg: "Henüz kodlanmadı!");
  }
}
