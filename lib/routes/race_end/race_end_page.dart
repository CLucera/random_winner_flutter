import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:random_winner_flutter/models/race_unit_model.dart';
import 'package:random_winner_flutter/services/achievements_service.dart';
import 'package:random_winner_flutter/ui/styles.dart';

import '../game/game_page.dart';

class RaceEndPage extends StatefulWidget {
  const RaceEndPage({
    Key? key,
    required this.imageBytes,
    required this.raceResult,
  }) : super(key: key);

  final Uint8List? imageBytes;
  final List<RaceUnitModel> raceResult;

  @override
  State<RaceEndPage> createState() => _RaceEndPageState();
}

class _RaceEndPageState extends State<RaceEndPage> {
  bool inited = false;

  @override
  void initState() {
    super.initState();
    AchievementsService.instance.incrementRacesRun();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        inited = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          final picture = Expanded(
            child: Column(children: [
              if (widget.imageBytes != null)
                Expanded(
                  child: AnimatedRotation(
                    turns: inited ? -0.012 : -1,
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.fastOutSlowIn,
                    child: AnimatedOpacity(
                      opacity: inited ? 1 : 0,
                      duration: const Duration(milliseconds: 800),
                      curve: const Interval(0.6, 1),
                      child: AnimatedScale(
                        scale: inited ? 1 : 3,
                        curve:
                            const Interval(0.5, 1, curve: Curves.fastOutSlowIn),
                        duration: const Duration(milliseconds: 1000),
                        child: Center(
                          child: Card(
                            elevation: 10,
                            color: Colors.white,
                            margin: const EdgeInsets.all(20),
                            child: Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              margin: const EdgeInsets.only(
                                top: 8.0,
                                left: 8.0,
                                right: 8.0,
                                bottom: 16.0,
                              ),
                              child: Image.memory(widget.imageBytes!),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: AnimatedScale(
                  scale: inited ? 1 : 0,
                  curve: const Interval(0.7, 1, curve: Curves.elasticOut),
                  duration: const Duration(milliseconds: 4000),
                  child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: Center(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              alignment: Alignment.bottomCenter,
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: const [
                                  Spacer(),
                                  Expanded(
                                    flex: 15,
                                    child: FittedBox(
                                      child: Text(
                                        "WINNER",
                                        style: TextStyle(
                                            color:
                                                RandomWinnerStyles.goldColor),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.topCenter,
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: FittedBox(
                                      child: Icon(
                                        Icons.emoji_events,
                                        color: RandomWinnerStyles.goldColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 10,
                                      child: FittedBox(
                                        child: Text(
                                          widget.raceResult.first.player.name,
                                          style: const TextStyle(
                                            color: RandomWinnerStyles.goldColor,
                                          ),
                                        ),
                                      )),
                                  const Expanded(
                                    child: FittedBox(
                                      child: Icon(
                                        Icons.emoji_events,
                                        color: RandomWinnerStyles.goldColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          );

          final arrivals = Expanded(
            child: AnimatedSlide(
              curve: const Interval(0.3, 1, curve: Curves.bounceOut),
              duration: const Duration(milliseconds: 3000),
              offset: Offset(0, inited ? 0 : 2),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.raceResult.length,
                      itemBuilder: (context, index) {
                        final Color color;
                        switch (index) {
                          case 0:
                            color = RandomWinnerStyles.goldColor;
                            break;
                          case 1:
                            color = RandomWinnerStyles.silverColor;
                            break;
                          case 2:
                            color = RandomWinnerStyles.bronzeColor;
                            break;
                          default:
                            color = Colors.white;
                        }
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${index + 1}° ${widget.raceResult[index].player.name}",
                            style: TextStyle(color: color, fontSize: 20),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 8.0,
                      bottom: 4.0,
                    ),
                    child: ElevatedButton(
                      onPressed: _restartRace,
                      child: const Text("RESTART RACE"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 4.0,
                      bottom: 4.0,
                    ),
                    child: ElevatedButton(
                      onPressed: _removeWinnerAndRestartRace,
                      child: const Text("REMOVE WINNER AND RESTART"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: 4.0,
                      bottom: 8.0,
                    ),
                    child: ElevatedButton(
                      onPressed: _toMainMenu,
                      child: const Text("MAIN MENU"),
                    ),
                  ),
                ],
              ),
            ),
          );
          if (orientation == Orientation.landscape) {
            return Row(
              children: [
                picture,
                arrivals,
              ],
            );
          } else {
            return Column(
              children: [
                picture,
                arrivals,
              ],
            );
          }
        },
      ),
    );
  }

  _restartRace() {
    _navigateToRace(false);
  }

  _removeWinnerAndRestartRace() {
    _navigateToRace(true);
  }

  _navigateToRace(bool skipWinner) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) {
        final orderedResult = [...widget.raceResult];
        if (skipWinner) {
          orderedResult.removeAt(0);
        }
        orderedResult.sort((a, b) {
          return a.originalIndex.compareTo(b.originalIndex);
        });
        return GamePage(orderedResult.map((e) => e.player).toList());
      },
    ));
  }

  _toMainMenu() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
