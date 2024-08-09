import 'package:equatable/equatable.dart';

import 'player.dart';

class RaceUnitModel extends Equatable {
  final Player player;
  final bool interactive;
  final int clops;
  final int percentage;
  final int startTimestamp;
  final int arrivalTimestamp;
  final int originalIndex;
  final Duration stepDuration;

  const RaceUnitModel({
    required this.player,
    this.interactive = false,
    this.clops = 0,
    this.percentage = 0,
    this.startTimestamp = 0,
    this.arrivalTimestamp = 0,
    this.originalIndex = 0,
    this.stepDuration = const Duration(milliseconds: 100),
  });

  @override
  List<Object?> get props => [player];

  RaceUnitModel copyWith({
    Player? player,
    bool? interactive,
    int? clops,
    int? percentage,
    int? startTimestamp,
    int? arrivalTimestamp,
    int? originalIndex,
    Duration? stepDuration,
  }) {
    return RaceUnitModel(
      player: player ?? this.player,
      interactive: interactive ?? this.interactive,
      clops: clops ?? this.clops,
      percentage: percentage ?? this.percentage,
      startTimestamp: startTimestamp ?? this.startTimestamp,
      arrivalTimestamp: arrivalTimestamp ?? this.arrivalTimestamp,
      originalIndex: originalIndex ?? this.originalIndex,
      stepDuration: stepDuration ?? this.stepDuration,
    );
  }
}
