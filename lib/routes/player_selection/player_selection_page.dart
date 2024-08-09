import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:random_winner_flutter/models/player.dart';
import 'package:random_winner_flutter/routes/game/game_page.dart';
import 'package:random_winner_flutter/routes/player_selection/player_select_text_field.dart';
import 'package:random_winner_flutter/ui/styles.dart';

class PlayerSelectionPage extends StatefulWidget {
  const PlayerSelectionPage({Key? key}) : super(key: key);

  @override
  _PlayerSelectionPageState createState() => _PlayerSelectionPageState();
}

class _PlayerSelectionPageState extends State<PlayerSelectionPage> {
  late List<Player> players = List.generate(
    2,
    (i) => Player(
      name: "",
      color: RandomWinnerStyles.getHorseColor(i),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PLAYER SELECTION")),
      body: OrientationBuilder(builder: (context, orientation) {
        return Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  return PlayerSelectTextField(
                    key: ValueKey(player),
                    index: index,
                    player: player,
                    onNameChanged: (name) {
                      players[index] = player.copyWith(
                        name: name,
                      );
                    },
                    onColorChanged: (color) {
                      if (color != null) {
                        _changeColor(index, color);
                      }
                    },
                    onDeleteTap: players.length > 2
                        ? () {
                            _removePlayer(player);
                          }
                        : null,
                  );
                },
              ),
            ),
            Container(
              color: Theme.of(context).colorScheme.surfaceContainer,
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Flex(
                direction: orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                mainAxisSize: orientation == Orientation.landscape
                    ? MainAxisSize.max
                    : MainAxisSize.min,
                crossAxisAlignment: orientation == Orientation.landscape
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.stretch,
                children: <Widget>[
                  Flexible(
                    fit: orientation == Orientation.landscape
                        ? FlexFit.tight
                        : FlexFit.loose,
                    child: ElevatedButton(
                      onPressed:
                          players.length < RandomWinnerStyles.horseColors.length
                              ? _addPlayer
                              : null,
                      child: const Text("ADD PLAYER"),
                    ),
                  ),
                  const SizedBox.square(dimension: 16),
                  Flexible(
                    fit: orientation == Orientation.landscape
                        ? FlexFit.tight
                        : FlexFit.loose,
                    child: ElevatedButton(
                      onPressed: _startRace,
                      child: const Text("START RACE"),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  _addPlayer() {
    Color? color = RandomWinnerStyles.horseColors.firstWhereOrNull(
      (color) => players.every((player) => color != player.color),
    );

    if (color != null) {
      setState(() => players.add(Player(name: "", color: color)));
    }
  }

  _changeColor(int playerIndex, Color newColor) {
    int? existingPlayerIndex;
    for (var i = 0; i < players.length; i++) {
      if (i != playerIndex && players[i].color == newColor) {
        existingPlayerIndex = i;
        break;
      }
    }

    setState(() {
      if (existingPlayerIndex != null) {
        players[existingPlayerIndex].copyWith(
          color: players[playerIndex].color,
        );
      }
      players[playerIndex] = players[playerIndex].copyWith(color: newColor);
    });
  }

  _removePlayer(Player player) {
    setState(() => players.remove(player));
  }

  _startRace() {
    final realList = <Player>[];
    for (var i = 0; i < players.length; i++) {
      final currentPlayer = players[i];
      realList.add(
        currentPlayer.copyWith(
          name: currentPlayer.name.trim().isEmpty
              ? "Player ${i + 1}"
              : currentPlayer.name,
        ),
      );
    }

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => GamePage(realList),
    ));
  }
}
