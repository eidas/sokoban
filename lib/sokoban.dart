import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';

import 'actors/player.dart';
import 'actors/crate.dart';
import 'objects/wall.dart';
import 'objects/ground.dart';
import 'objects/goal.dart';
import 'managers/stage_manager.dart';
import 'package:flutter/material.dart';
import 'package:sokoban/utils/int_vector2.dart';

class SokobanGame extends FlameGame with KeyboardEvents {
  SokobanGame();

  Player _player = Player(gridPosition: IntVector2(-1, -1));
  List<Crate> _crates = [];
  // double objectSpeed = 0.0;

  @override
  Color backgroundColor() {
    return Color.fromARGB(255, 24, 59, 76);
  }

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'player.png',
      'crate.png',
      'wall.png',
      'ground.png',
      'goal.png',
    ]);
    initializeGame();
  }

  @override
  void update(double dt) {
    if (judgeStageClear()) {
      overlays.add('StageClear');
    }
    super.update(dt);
  }

  void loadGameSegments() {
    var pos = IntVector2(0, 0);
    for (int j = 0; j < tileColumns; j++) {
      for (int i = 0; i < tileColumns; i++) {
        pos = IntVector2(i, j);
        switch (stageData[j][i]) {
          case Tile.Ground:
            add(Ground(
              gridPosition: pos,
            ));
            break;
          case Tile.Wall:
            add(Wall(
              gridPosition: pos,
            ));
            break;
          case Tile.Goal:
            add(Ground(
              gridPosition: pos,
            ));
            add(Goal(
              gridPosition: pos,
            ));
            break;
          case Tile.Crate:
            add(Ground(
              gridPosition: pos,
            ));
            var crate = Crate(
              gridPosition: pos,
              isOnGoal: false,
            );
            _crates.add(crate);
            // add(crate);
            break;
          case Tile.CrateAndGoal:
            add(Ground(
              gridPosition: pos,
            ));
            add(Goal(
              gridPosition: pos,
            ));
            var crate = Crate(
              gridPosition: pos,
              isOnGoal: true,
            );
            _crates.add(crate);
            // add(crate);
            break;
          default:
            break;
        }
      }
    }
  }

  void initializeGame() {
    _crates = [];
    readStageData(stageDataStr);
    removeAll(children); // 2回目以降のため追加されたコンポーネントを一度全部削除
    loadGameSegments();
    for (var _crate in _crates) {
      add(_crate);
    }

    _player = Player(
      gridPosition: IntVector2(playerX, playerY),
      xOffset: 0.0,
    );
    add(_player);
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    // final isKeyDown = event is RawKeyDownEvent;
    var horizontalDirection = 0;
    var verticalDirection = 0;

    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyA) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? -1
        : 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;
    verticalDirection += (keysPressed.contains(LogicalKeyboardKey.keyW) ||
            keysPressed.contains(LogicalKeyboardKey.arrowUp))
        ? -1
        : 0;
    verticalDirection += (keysPressed.contains(LogicalKeyboardKey.keyS) ||
            keysPressed.contains(LogicalKeyboardKey.arrowDown))
        ? 1
        : 0;

    // プレイヤーが移動中はキーイベントを無視
    if (_player.isMoving) return KeyEventResult.ignored;

    if (horizontalDirection.abs() + verticalDirection.abs() == 1) {
      playerMove(horizontalDirection, verticalDirection);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void playerMove(int horizontalDirection, int verticalDirection) {
    IntVector2 gridMoveTo = _player.gridPosition +
        IntVector2(horizontalDirection, verticalDirection);
    var x = gridMoveTo.x;
    var y = gridMoveTo.y;

    // 移動可否の判定
    var oneStepAhead = stageData[y][x]; // 一歩先
    if (oneStepAhead == Tile.Wall) return;
    // プレイヤーの先に荷物がある場合
    if (oneStepAhead == Tile.Crate || oneStepAhead == Tile.CrateAndGoal) {
      IntVector2 crateMoveTo =
          gridMoveTo + IntVector2(horizontalDirection, verticalDirection);
      var cx = crateMoveTo.x;
      var cy = crateMoveTo.y;
      var twoStepAhead = stageData[cy][cx]; // 二歩先
      // 荷物の移動先がゴールでも地面でもない時は動かせない
      if (twoStepAhead != Tile.Goal && twoStepAhead != Tile.Ground) return;

      // 荷物のスプライトを探す
      var crate = findCrate(gridMoveTo);

      // 荷物移動
      var onGoal = (twoStepAhead == Tile.Goal); // 移動先がゴールか
      crate.moveTo(crateMoveTo, onGoal, () {
        // マップ更新
        stageData[y][x] =
            (oneStepAhead == Tile.CrateAndGoal ? Tile.Goal : Tile.Ground);
        stageData[cy][cx] =
            (twoStepAhead == Tile.Goal ? Tile.CrateAndGoal : Tile.Crate);
      });
    }
    _player.moveTo(gridMoveTo);
  }

  Crate findCrate(IntVector2 gridPosition) {
    return _crates.firstWhere((element) =>
        element.gridPosition.x == gridPosition.x &&
        element.gridPosition.y == gridPosition.y);
  }

  void reset() {
    initializeGame();
  }
}
