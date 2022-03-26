import 'package:flutter/material.dart';

class RandomWinnerStyles {
  static const horseColors = Colors.accents;

  static const goldColor = Color(0xffC9B037);
  static const silverColor = Color(0xffD7D7D7);
  static const bronzeColor = Color(0xff965A38);

  static Color getHorseColor(int color) {
    return horseColors[color % horseColors.length];
  }
}
