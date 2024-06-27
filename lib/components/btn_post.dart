import 'package:flutter/material.dart';

class PostButton extends StatelessWidget{
  final Function()? onClicked;
  final String btnText;

  const PostButton({
    super.key,
    required this.onClicked,
    required this.btnText
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClicked,
      child: Container(
        width: 124,
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black)
        ),
        child:  Center(
          child: Text(
            btnText,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  } 
}