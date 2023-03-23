import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:sokoban/objects/grid_object.dart';
import 'package:flutter/material.dart';
import 'package:sokoban/utils/int_vector2.dart';

class Goal extends GridObject {
  Goal({
    required IntVector2 gridPosition,
    double xOffset = 0,
    double yOffset = 0,
  }) : super(
          gridPosition: gridPosition,
          xOffset: xOffset,
          yOffset: yOffset,
          imageFileName: 'goal.png',
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(
      SizeEffect.by(
        Vector2(-24, -24),
        EffectController(
          duration: .75,
          reverseDuration: .5,
          infinite: true,
          curve: Curves.easeOut,
        ),
      ),
    );
  }
}
