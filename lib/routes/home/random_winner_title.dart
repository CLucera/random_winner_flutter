import 'package:flutter/material.dart';
import 'package:random_winner_flutter/ui/horse_widget.dart';
import 'package:random_winner_flutter/ui/styles.dart';

class RandomWinnerTitle extends StatefulWidget {
  const RandomWinnerTitle({Key? key}) : super(key: key);

  @override
  State<RandomWinnerTitle> createState() => _RandomWinnerTitleState();
}

class _RandomWinnerTitleState extends State<RandomWinnerTitle> {
  var clops = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _animateTitle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Expanded(
          flex: 2,
          child: FittedBox(
            child: HorseWidget(
              clops: clops,
              color: RandomWinnerStyles.getHorseColor(clops),
            ),
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FittedBox(
              child: Text(
                "RandomWinner",
                style: TextStyle(
                  color: RandomWinnerStyles.getHorseColor(clops),
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 2,
          child: FittedBox(
            child: HorseWidget(
              clops: clops,
              color: RandomWinnerStyles.getHorseColor(clops),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  void _animateTitle() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => ++clops);
      _animateTitle();
    }
  }
}
