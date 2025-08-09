import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_winner_flutter/constants/assets.dart';
import 'package:random_winner_flutter/models/race_unit_model.dart';
import 'package:random_winner_flutter/routes/game/race_widget.dart';
import 'package:random_winner_flutter/services/achievements_service.dart';
import 'package:soundpool/soundpool.dart';

class GameRace extends StatefulWidget {
  const GameRace({
    Key? key,
    required this.raceUnits,
    required this.onFirstArrived,
    required this.onRaceEnded,
    this.onRaceUpdated,
  }) : super(key: key);

  final List<RaceUnitModel> raceUnits;
  final Function(RaceUnitModel firstArrived) onFirstArrived;
  final Function(List<RaceUnitModel> raceResult) onRaceEnded;
  final Function(List<RaceUnitModel> raceResult)? onRaceUpdated;

  @override
  State<GameRace> createState() => _GameRaceState();
}

class _GameRaceState extends State<GameRace> {
  final Soundpool pool = Soundpool.fromOptions();
  late final Random random = Random(DateTime.now().millisecondsSinceEpoch);

  int? soundId;
  int lastClopPlayed = 0;
  bool raceStarted = false;
  late List<RaceUnitModel> raceUnits;
  RaceUnitModel? firstPlace;
  double _maxWidth = 0;

  @override
  void initState() {
    int index = 0;
    raceUnits = widget.raceUnits
        .map((e) => e.copyWith(originalIndex: index++))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _maxWidth = constraints.maxWidth;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          ...raceUnits
              .map(
                (e) => RaceWidget(
                  key: ValueKey(e.player),
                  right: _computeDistance(e.percentage, constraints.maxWidth),
                  height: _computeHeight(constraints.maxHeight),
                  raceModel: e,
                  top: _computeVerticalPosition(
                    e.originalIndex,
                    constraints.maxHeight,
                  ),
                  duration: e.stepDuration,
                ),
              )
              .toList(),
          if (!raceStarted)
            Center(
              child: ElevatedButton(
                onPressed: _startRace,
                child: const Text("START RACE"),
              ),
            ),
          if (raceStarted)
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: _manualClop,
                child: const Text("START RACE"),
              ),
            ),
        ],
      );
    });
  }

  _startRace() {
    setState(() {
      final now = DateTime.now().millisecondsSinceEpoch;
      for (int i = 0; i < raceUnits.length; i++) {
        raceUnits[i] = raceUnits[i].copyWith(startTimestamp: now);
      }
      raceStarted = true;
      raceUnits.shuffle(random);
      for (final raceUnit in raceUnits) {
        if (raceUnit.interactive) {
          continue;
        }
        Future.delayed(_stepDuration, () => _step(raceUnit));
      }
    });
  }

  _manualClop() {
    setState(() {
      _step(raceUnits.firstWhere((e) => e.interactive));
    });
  }

  double _computeDistance(int percentage, double parentWidth) {
    return parentWidth - (parentWidth / 100 * percentage) - 30;
  }

  double _computeHeight(double parentHeight) {
    return parentHeight / 10;
  }

  double _computeVerticalPosition(int index, double parentHeight) {
    final align =
        lerpDouble(-0.9, 0.9, (index + 1) / (widget.raceUnits.length + 1));

    return (parentHeight / 2) +
        (parentHeight / 2 * align!) -
        _computeHeight(parentHeight) / 2;
  }

  Duration get _stepDuration {
    return Duration(milliseconds: random.nextInt(300) + 100);
  }

  void _step(RaceUnitModel unitModel) async {
    Duration stepDuration =
        unitModel.interactive ? Duration.zero : _stepDuration;

    raceUnits.sort((a, b) => a.percentage.compareTo(b.percentage));

    if (!mounted) {
      return;
    }
    soundId ??= await rootBundle
        .load(RandomWinnerSFX.clop)
        .then((ByteData soundData) => pool.load(soundData));

    final now = DateTime.now().millisecondsSinceEpoch;
    if (soundId != null && now - lastClopPlayed > 300) {
      lastClopPlayed = now;
      pool.play(soundId!);
    }

    Future.delayed(stepDuration, () {
      final delta = random.nextInt(4);
      final pixelsMoved = (_maxWidth / 100) * delta;
      AchievementsService.instance.addPixelsTravelled(pixelsMoved);

      final raceModelIndex = raceUnits.indexOf(unitModel);
      final nextPercentage = unitModel.percentage + delta;
      final nextClops = unitModel.clops + 1;
      final justArrived =
          unitModel.arrivalTimestamp == 0 && nextPercentage >= 100;
      final newModel = unitModel.copyWith(
        clops: nextClops,
        percentage: nextPercentage,
        arrivalTimestamp:
            justArrived ? DateTime.now().millisecondsSinceEpoch : null,
      );
      raceUnits[raceModelIndex] = newModel;
      raceUnits.sort((a, b) => b.percentage.compareTo(a.percentage));

      if (widget.onRaceUpdated != null) {
        final currentOrder = [...raceUnits];
        currentOrder.sort(
          (a, b) {
            int arrival = a.arrivalTimestamp.compareTo(b.arrivalTimestamp);
            if (arrival != 0) return arrival;
            return b.percentage.compareTo(a.percentage);
          },
        );
        widget.onRaceUpdated?.call(currentOrder);
      }

      if (justArrived) {
        if (firstPlace == null) {
          firstPlace = newModel;
          widget.onFirstArrived(firstPlace!);
        } else if (raceUnits.every((element) => element.arrivalTimestamp > 0)) {
          final arrivalOrder = [...raceUnits];
          arrivalOrder.sort(
            (a, b) => a.arrivalTimestamp.compareTo(b.arrivalTimestamp),
          );
          widget.onRaceEnded(arrivalOrder);
        }
      }
      if (!mounted) {
        return;
      }
      if (!newModel.interactive) {
        setState(() {});
        _step(newModel);
      }
    });
  }
}
