import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';

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

  IntVector2 playerPosition = IntVector2(-1, -1);
  Player _player = Player(gridPosition: IntVector2(-1, -1));
  List<Crate> _crates = [];
  // double objectSpeed = 0.0;
  int gameStep = 0;

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
    if (_player.isMoving == false && judgeStageClear()) {
      overlays.add('StageClear');
    }
    super.update(dt);
  }

  void loadGameSegments() {
    var pos = IntVector2(0, 0);
    for (int j = 0; j < tileColumns; j++) {
      for (int i = 0; i < tileColumns; i++) {
        pos = IntVector2(i, j);
        switch (board.boardData[j][i]) {
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
    gameStep = 0;

    // プレイヤー初期配置
    playerPosition = IntVector2(playerX, playerY);
    _player = Player(
      gridPosition: playerPosition,
      xOffset: 0.0,
    );
    add(_player);
    // camera.followComponent(_player);

    // リプレイデータstep0作成
    replayList = [ReplayData(board, playerPosition, null)];
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    // final isKeyDown = event is RawKeyDownEvent;
    var horizontalDirection = 0;
    var verticalDirection = 0;

    // プレイヤーが移動中はキーイベントを無視
    if (_player.isMoving) return KeyEventResult.ignored;

    // Undo,Redoのキー入力処理
    if (keysPressed.contains(LogicalKeyboardKey.digit1)) {
      undo();
      return KeyEventResult.handled;
    } else if (keysPressed.contains(LogicalKeyboardKey.digit2)) {
      redo();
      return KeyEventResult.handled;
    }

    // 各方向キーの入力
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
    IntVector2? crateNewPosition;
    var newBoard = Board.clone(board);

    // 移動可否の判定
    var oneStepAhead = board.boardData[y][x]; // 一歩先
    if (oneStepAhead == Tile.Wall) return;
    // プレイヤーの先に荷物がある場合
    if (oneStepAhead == Tile.Crate || oneStepAhead == Tile.CrateAndGoal) {
      IntVector2 crateMoveTo =
          gridMoveTo + IntVector2(horizontalDirection, verticalDirection);
      var cx = crateMoveTo.x;
      var cy = crateMoveTo.y;
      var twoStepAhead = board.boardData[cy][cx]; // 二歩先
      // 荷物の移動先がゴールでも地面でもない時は動かせない
      if (twoStepAhead != Tile.Goal && twoStepAhead != Tile.Ground) return;

      // 荷物のスプライトを探す
      var crate = findCrate(gridMoveTo);
      if (crate == null) {
        resetCrateSprites();
      } else {
        // 荷物移動
        var onGoal = (twoStepAhead == Tile.Goal); // 移動先がゴールか
        crate.moveTo(crateMoveTo, onGoal, () {});
      }

      // マップ更新
      newBoard.boardData[y][x] =
          (oneStepAhead == Tile.CrateAndGoal ? Tile.Goal : Tile.Ground);
      newBoard.boardData[cy][cx] =
          (twoStepAhead == Tile.Goal ? Tile.CrateAndGoal : Tile.Crate);
      crateNewPosition = IntVector2(cx, cy);
    }

    // プレイヤー位置更新
    playerPosition = gridMoveTo;
    _player.moveTo(gridMoveTo);

    // リプレイリスト更新
    if (gameStep + 1 < replayList.length) {
      // 現在のgameStepがリプレイリストの途中であれば、gameStep以降のリプレイリストを破棄
      replayList.removeRange(gameStep + 1, replayList.length);
    }
    replayList.add(ReplayData(newBoard, playerPosition, crateNewPosition));
    gameStep++;
    board = newBoard;

    // デバッグ時のみ実行されます
    assert(() {
      stageViewer();
      return true; // assert()の戻り値はbool型で、trueを返します
    }());
  }

  // 1手もどす(アンドゥ)
  void undo() {
    if (gameStep <= 0) return; // step=0の時はundoできない
    gameStep--;
    var currentReplayData = replayList[gameStep];
    var nextReplayData = replayList[gameStep + 1];
    board = currentReplayData.board;
    // TODO: プレイヤー移動
    playerPosition = currentReplayData.player_pos;
    _player.moveTo(playerPosition, isReverse: true);
    // TODO: 荷物移動
    if (nextReplayData.crate_pos != null) {
      var crate = findCrate(nextReplayData.crate_pos!); // 次の手の
      if (crate == null) {
        resetCrateSprites();
      } else {
        crate.moveTo(nextReplayData.player_pos,
            isGoal(nextReplayData.player_pos), () {});
      }
    }

    // デバッグ時のみ実行されます
    assert(() {
      stageViewer();
      return true; // assert()の戻り値はbool型で、trueを返します
    }());
  }

  // 1手すすめる(リドゥ) - リプレイリストがある時だけ
  void redo() {
    if (replayList.length <= gameStep + 1) return; // 次にリプレイデータがない時はredoできない
    gameStep++;
    var currentReplayData = replayList[gameStep];
    var previousReplayData = replayList[gameStep - 1];
    board = currentReplayData.board;
    // TODO: プレイヤー移動
    playerPosition = currentReplayData.player_pos;
    _player.moveTo(playerPosition);
    // TODO: 荷物移動
    if (currentReplayData.crate_pos != null) {
      var crate =
          findCrate(currentReplayData.player_pos!); // 1手前のプレイヤーの位置が荷物の元の位置
      if (crate == null) {
        resetCrateSprites();
      } else {
        crate.moveTo(currentReplayData.crate_pos!,
            isGoal(currentReplayData.crate_pos!), () {});
      }
    }

    // デバッグ時のみ実行されます
    assert(() {
      stageViewer();
      return true; // assert()の戻り値はbool型で、trueを返します
    }());
  }

  Crate? findCrate(IntVector2 gridPosition) {
    return _crates.firstWhereOrNull(
      (element) =>
          element.gridPosition.x == gridPosition.x &&
          element.gridPosition.y == gridPosition.y,
    );
  }

  bool isGoal(IntVector2 pos) {
    var tile = board.boardData[pos.y][pos.x];
    return tile == Tile.Goal || tile == Tile.CrateAndGoal;
  }

  void resetCrateSprites() {
    children.whereType<Crate>().map((e) => remove(e));
    _crates = [];

    var pos = IntVector2(0, 0);
    for (int j = 0; j < tileColumns; j++) {
      for (int i = 0; i < tileColumns; i++) {
        pos = IntVector2(i, j);
        switch (board.boardData[j][i]) {
          case Tile.Crate:
            var crate = Crate(
              gridPosition: pos,
              isOnGoal: false,
            );
            _crates.add(crate);
            break;
          case Tile.CrateAndGoal:
            var crate = Crate(
              gridPosition: pos,
              isOnGoal: true,
            );
            _crates.add(crate);
            break;
          default:
            break;
        }
      }
    }
  }

  void reset() {
    initializeGame();
  }

// for Test
  void stageViewer() {
    for (var s in getXsokobanString(board)) {
      print(s);
    }
    print('step=${gameStep}');
    print('player x,y=${playerPosition.x},${playerPosition.y}');
  }
}
