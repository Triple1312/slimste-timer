



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShadedTextButton extends StatelessWidget {
  ShadedTextButton({super.key, required this.text, required this.onPressed});

  String text;
  Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
        colors: [Color.fromARGB(255, 177, 25, 20), Color.fromARGB(255, 239, 83, 45)],
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: TextButton(
        onPressed: () => onPressed(),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}