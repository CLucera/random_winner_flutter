import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({
    required this.screenshotController,
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final ScreenshotController screenshotController;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Screenshot(
        controller: screenshotController,
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Stack(
            children: <Widget>[
              //Race background
              Positioned.fill(
                  child: Row(
                children: [
                  Container(
                    width: 30,
                    color: Colors.grey,
                    child: const Center(
                      child: Text(
                        "S\n\nT\n\nA\n\nR\n\nT",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 30,
                    color: Colors.grey,
                    child: const Center(
                      child: Text(
                        "F\n\nI\n\nN\n\nI\n\nS\n\nH",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              )),
              Positioned.fill(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
