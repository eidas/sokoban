import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'overlays/stage_clear.dart';
import 'overlays/main_menu.dart';
import 'sokoban.dart';

void main() {
  runApp(
    GameWidget<SokobanGame>.controlled(
      gameFactory: SokobanGame.new,
      overlayBuilderMap: {
        'MainMenu': (_, game) => MainMenu(game: game),
        'StageClear': (_, game) => StageClear(game: game),
      },
      initialActiveOverlays: const ['MainMenu'],
    ),
  );
}
