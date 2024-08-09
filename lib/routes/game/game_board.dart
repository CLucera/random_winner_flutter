import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

const _BAR_WIDTH = 30.0;

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
    final colorScheme = Theme.of(context).colorScheme;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Screenshot(
        controller: screenshotController,
        child: Container(
          color: colorScheme.surface,
          child: Stack(
            children: <Widget>[
              //Race background
              Positioned.fill(
                  child: Row(
                children: [
                  Container(
                    width: _BAR_WIDTH,
                    height: double.infinity,
                    color: colorScheme.surfaceContainerHighest,
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "S\n\nT\n\nA\n\nR\n\nT",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: _BAR_WIDTH,
                    height: double.infinity,
                    color: colorScheme.surfaceContainerHighest,
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
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
