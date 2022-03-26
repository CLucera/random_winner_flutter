import 'package:flutter/material.dart';
import 'package:random_winner_flutter/constants/assets.dart';

class HorseWidget extends StatelessWidget {
  final int clops;
  final Color color;

  const HorseWidget({
    Key? key,
    this.clops = 0,
    this.color = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      RandomWinnerImages
          .horseImages[clops % RandomWinnerImages.horseImages.length],
      color: color,
      width: 80,
      height: 80,
    );
  }
}
