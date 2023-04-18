import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:sokoban/sokoban.dart';

class Hud extends PositionComponent with HasGameRef<SokobanGame> {
  Hud({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority = 5,
  }) {
    positionType = PositionType.viewport;
  }

  late TextComponent _stepsTextComponent;
  late TextComponent _stageTextComponent;
  double _gameSizeX = 0.0;
  int _gameSteps = 0;

  String get stageText => game.localizations.stageText(game.stageName);
  String get stepsText => game.localizations.stepsText(game.gameSteps);
  Vector2 get stepsPosition => Vector2(game.size.x - 10, 10);

  @override
  Future<void>? onLoad() async {
    // ステップ数テキスト
    _stepsTextComponent = TextComponent(
      text: stepsText,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
      ),
      anchor: Anchor.topRight,
      position: stepsPosition,
    );
    add(_stepsTextComponent);

    // ステージテキスト
    _stageTextComponent = TextComponent(
      text: stageText,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
      ),
      anchor: Anchor.topLeft,
      position: Vector2(10, 10),
    );
    add(_stageTextComponent);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // 関係する値に変更があった時だけ書き換え、のつもり
    if (_gameSteps != game.gameSteps || _gameSizeX != game.size.x) {
      _gameSteps = game.gameSteps;
      _gameSizeX = game.size.x;
      _stepsTextComponent
        ..text = stepsText
        ..position = stepsPosition;
    }
    super.update(dt);
  }
}
