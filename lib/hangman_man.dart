import 'package:flutter/material.dart';

class HangmanGraphic extends StatelessWidget {
  final int hangmanGraphicIndex;

  const HangmanGraphic({Key? key, required this.hangmanGraphicIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imagePath = 'images/$hangmanGraphicIndex.png';

    return Image.asset(
      imagePath,
      fit: BoxFit.scaleDown,
    );
  }
}
