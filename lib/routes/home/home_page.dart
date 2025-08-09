import 'package:flutter/material.dart';
import 'package:random_winner_flutter/models/player.dart';
import 'package:random_winner_flutter/routes/achievements/achievements_page.dart';
import 'package:random_winner_flutter/routes/game/game_page.dart';
import 'package:random_winner_flutter/routes/home/random_winner_title.dart';
import 'package:random_winner_flutter/routes/player_selection/player_selection_page.dart';
import 'package:random_winner_flutter/ui/styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return Column(
          children: [
            const Expanded(
              child: RandomWinnerTitle(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Flex(
                direction: orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                mainAxisAlignment: orientation == Orientation.landscape
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.center,
                crossAxisAlignment: orientation == Orientation.landscape
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: _startClassic,
                    child: const Text("START CLASSIC"),
                  ),
                  if (orientation == Orientation.portrait)
                    const SizedBox.square(dimension: 20),
                  ElevatedButton(
                    onPressed: _startRace,
                    child: const Text("START FROM LIST"),
                  ),
                  if (orientation == Orientation.portrait)
                    const SizedBox.square(dimension: 20),
                  ElevatedButton(
                    onPressed: _goToAchievements,
                    child: const Text("ACHIEVEMENTS"),
                  )
                ],
              ),
            ),
            Expanded(
              flex: orientation == Orientation.landscape ? 1 : 2,
              child: Card(
                margin: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: textController,
                    maxLines: null,
                    style: const TextStyle(height: 1.5),
                    decoration: const InputDecoration(
                      hintText: "Insert list of player separated by comma",
                      hintMaxLines: 2,
                      border: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  _startClassic() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const PlayerSelectionPage(),
    ));
  }

  _goToAchievements() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AchievementsPage(),
    ));
  }

  _startRace() {
    final playerNames = textController.text
        .split(",")
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .toList();

    if (playerNames.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please insert at least 2 valid player names"),
        ),
      );
      return;
    }

    var index = 0;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => GamePage(
        playerNames
            .map(
              (name) => Player(
                name: name,
                color: RandomWinnerStyles.getHorseColor(index++),
              ),
            )
            .toList(),
      ),
    ));
  }
}
