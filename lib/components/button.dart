import 'package:flutter/material.dart';

class MyButton extends StatelessWidget{
  final Function()? onClicked;
  final String btnText;

  const MyButton({
    super.key,
    required this.onClicked,
    required this.btnText
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClicked,
      child: Container(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 16, bottom: 16),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child:  Center(
          child: Text(
            btnText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  } 
}