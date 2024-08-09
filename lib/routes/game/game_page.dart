import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:random_winner_flutter/models/player.dart';
import 'package:random_winner_flutter/models/race_unit_model.dart';
import 'package:random_winner_flutter/routes/game/game_board.dart';
import 'package:random_winner_flutter/routes/game/game_race.dart';
import 'package:random_winner_flutter/routes/race_end/race_end_page.dart';
import 'package:screenshot/screenshot.dart';

typedef OnPlayerArrived = Function(Player player);

int lastPlayed = 0;

class GamePage extends StatefulWidget {
  final List<Player> players;

  const GamePage(this.players, {Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Duration photoFinishDuration = const Duration(milliseconds: 500);
  late List<RaceUnitModel> currentOrder = [];
  late int soundId;
  double photoFinishOpacity = 0;
  Uint8List? imageData;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        OrientationBuilder(builder: (context, orientation) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: ColoredBox(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: GameBoard(
                      screenshotController: screenshotController,
                      child: GameRace(
                        raceUnits: widget.players
                            .map((e) => RaceUnitModel(player: e, interactive: e.name == "Player 1"))
                            .toList(),
                        onRaceEnded: _finishRace,
                        onRaceUpdated: _updateRace,
                        onFirstArrived: (firstArrived) {
                          _photoFinish();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              if (orientation == Orientation.portrait)
                Expanded(
                  child: ListView(
                    children: [
                      for (final unitModel in currentOrder)
                        Padding(
                          key: ValueKey(unitModel),
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              unitModel.player.name,
                              style: TextStyle(
                                color: unitModel.player.color,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
            ],
          );
        }),
        Positioned.fill(
            child: IgnorePointer(
          child: AnimatedOpacity(
            opacity: photoFinishOpacity,
            duration: photoFinishDuration,
            curve: Curves.bounceOut,
            child: Container(color: Colors.white),
          ),
        ))
      ],
    ));
  }

  _photoFinish() async {
    final result = await screenshotController.captureAsUiImage();
    final pngBytes = await result?.toByteData(format: ImageByteFormat.png);
    imageData = pngBytes != null ? Uint8List.view(pngBytes.buffer) : null;
    // setState(() {});

    setState(() => photoFinishOpacity = 1);
    await Future.delayed(
      photoFinishDuration,
      () => setState(
        () => photoFinishOpacity = 0,
      ),
    );
  }

  _finishRace(List<RaceUnitModel> raceResult) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => RaceEndPage(
          imageBytes: imageData!,
          raceResult: raceResult,
        ),
      ),
    );
  }

  _updateRace(List<RaceUnitModel> raceResult) {
    if (mounted) {
      setState(() {
        currentOrder = raceResult;
      });
    }
  }
}
