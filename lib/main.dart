import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'overlays/stage_clear.dart';
import 'overlays/main_menu.dart';
import 'sokoban.dart';
import 'package:sokoban/overlays/navidatiion_keys.dart';
import 'package:sokoban/overlays/menu_keys.dart';

void main() {
  final game = SokobanGame();
  runApp(
    // MaterialApp(
    //       debugShowCheckedModeBanner: false,
    //       home: Scaffold(
    //         body:
    GameWidget<SokobanGame>.controlled(
      gameFactory: SokobanGame.new,
      // gameFactory: game,
      overlayBuilderMap: {
        'MainMenu': (_, game) => MainMenu(game: game),
        'StageClear': (_, game) => StageClear(game: game),
        'NavigationKey': (_, game) => Align(
              alignment: Alignment.bottomLeft,
              child: NavigationKeys(
                game: game,
                onDirectionChanged: game.onVirtualKeyChanged,
              ),
            ),
        'MenuKey': (_, game) => Align(
              alignment: Alignment.bottomRight,
              child: MenuKeys(
                game: game,
                onMenuSelected: game.onVirtualKeyChanged,
              ),
            ),
      },
      initialActiveOverlays: const ['MainMenu', 'NavigationKey', 'MenuKey'],
    ),
    // ),
  );
}
