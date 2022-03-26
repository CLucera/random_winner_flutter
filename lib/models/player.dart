import 'dart:ui';

import 'package:equatable/equatable.dart';

class Player extends Equatable {
  final String name;
  final Color color;

  const Player({
    required this.name,
    required this.color,
  });

  Player copyWith({
    String? name,
    Color? color,
  }) {
    return Player(
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [name, color];
}
