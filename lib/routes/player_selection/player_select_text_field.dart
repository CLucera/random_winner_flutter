import 'package:flutter/material.dart';
import 'package:random_winner_flutter/models/player.dart';
import 'package:random_winner_flutter/ui/horse_widget.dart';
import 'package:random_winner_flutter/ui/styles.dart';

class PlayerSelectTextField extends StatelessWidget {
  const PlayerSelectTextField({
    Key? key,
    required this.index,
    required this.player,
    required this.onNameChanged,
    required this.onColorChanged,
    this.onDeleteTap,
  }) : super(key: key);

  final int index;
  final Player player;
  final ValueChanged<String>? onNameChanged;
  final ValueChanged<Color?>? onColorChanged;
  final VoidCallback? onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: HorseWidget(color: player.color),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.white,
            child: Theme(
              data: ThemeData(
                  fontFamily: "PressStart", brightness: Brightness.light),
              child: TextFormField(
                initialValue: player.name,
                onChanged: onNameChanged,
                decoration: InputDecoration(
                  hintText: "Player ${index + 1}",
                  contentPadding: const EdgeInsets.all(8),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 40,
          height: 50,
          child: Card(
            color: player.color,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Color>(
                isExpanded: true,
                hint: const SizedBox(),
                focusColor: player.color,
                icon: Container(),
                onChanged: onColorChanged,
                items: [
                  for (Color color in RandomWinnerStyles.horseColors)
                    DropdownMenuItem(
                      value: color,
                      child: HorseWidget(color: color),
                    )
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: onDeleteTap,
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("X"),
          ),
        ),
      ],
    );
  }
}
