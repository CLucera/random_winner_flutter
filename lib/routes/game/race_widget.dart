import 'package:flutter/material.dart';
import 'package:random_winner_flutter/models/race_unit_model.dart';
import 'package:random_winner_flutter/ui/horse_widget.dart';

class RaceWidget extends StatelessWidget {
  const RaceWidget({
    Key? key,
    required this.raceModel,
    required this.top,
    required this.height,
    required this.right,
    required this.duration,
  }) : super(key: key);

  final RaceUnitModel raceModel;
  final double top;
  final double height;
  final double right;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: top,
      height: height,
      right: right,
      duration: duration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: height * 0.40,
            padding: EdgeInsets.all(height / 10),
            color: raceModel.player.color,
            child: FittedBox(
              child: Center(
                child: Text(
                  raceModel.player.name,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          SizedBox(
            height: height > 0 ? height : 1,
            child: FittedBox(
              child: HorseWidget(
                clops: raceModel.clops,
                color: raceModel.player.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
