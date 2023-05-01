import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:sokoban/helper/bgm_player.dart';

import 'actors/player.dart';
import 'actors/crate.dart';
import 'constants.dart';
import 'helper/user_command.dart';
import 'objects/wall.dart';
import 'objects/ground.dart';
import 'objects/goal.dart';
import 'managers/stage_manager.dart';
import 'package:sokoban/utils/int_vector2.dart';
import 'package:sokoban/overlays/hud.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sokoban/helper/setting.dart';

class SokobanGame extends FlameGame
    with KeyboardEvents, ScrollDetector, ScaleDetector {
  SokobanGame(
    this.context,
    this.localizations,
    this.setting,
    this.stageName,
  );

  final BuildContext context;
  final AppLocalizations localizations;
  final Setting setting;
  final String stageName;
  IntVector2 playerPosition = IntVector2(-1, -1);
  Player _player = Player(gridPosition: IntVector2(-1, -1));
  List<Crate> _crates = [];
  // double objectSpeed = 0.0;
  int gameSteps = 0;
  List<UserCommand> userCommands = [];

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 24, 59, 76);
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
    await initializeGame();
  }

  @override
  void update(double dt) {
    executeUserCommand();
    if (_player.isMoving == false && judgeStageClear()) {
      overlays.add('StageClear');
    }
    super.update(dt);
  }

  /// 面データからスプライト生成
  void loadGameSegments() {
    var pos = IntVector2(0, 0);
    for (int j = 0; j < tileRows; j++) {
      for (int i = 0; i < tileColumns; i++) {
        pos = IntVector2(i, j);
        switch (board.boardData[j][i]) {
          case Tile.ground:
            add(Ground(
              gridPosition: pos,
            ));
            break;
          case Tile.wall:
            add(Wall(
              gridPosition: pos,
            ));
            break;
          case Tile.goal:
            add(Ground(
              gridPosition: pos,
            ));
            add(Goal(
              gridPosition: pos,
            ));
            break;
          case Tile.crate:
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
          case Tile.crateAndGoal:
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

  /// ゲーム初期化
  Future<void> initializeGame() async {
    _crates = [];
    userCommands = [];
    await loadAssetsStageDataTextFile('assets/stageData/$stageName');
    // await readStageDataFromFile('assets/stageData/${stageName}');
    // readStageData(const_stageDataStr);
    removeAll(children); // 2回目以降のため追加されたコンポーネントを一度全部削除
    loadGameSegments();
    for (var crate in _crates) {
      add(crate);
    }
    gameSteps = 0;

    // プレイヤー初期配置
    playerPosition = IntVector2(playerX, playerY);
    _player = Player(
      gridPosition: playerPosition,
      xOffset: 0.0,
    );
    add(_player);

    // カメラ
    camera.viewport = FixedResolutionViewport(canvasSize);
    camera.setRelativeOffset(Anchor.topLeft);
    camera.speed = 100;
    camera.worldBounds = Rect.fromLTWH(
        0,
        0,
        max(tileColumns * Constants.tileSize, canvasSize.x),
        max(tileRows * Constants.tileSize, canvasSize.y));

    // camera.followComponent(
    //   _player,
    //   relativeOffset: Anchor.topLeft,
    //   worldBounds: Rect.fromLTWH(0, 0, tileColumns * Constants.tileSize - 1,
    //       tileRows * Constants.tileSize - 1),
    // );

    // リプレイデータstep0作成
    replayList = [ReplayData(board, playerPosition, null)];

    // ステータステキスト表示用コンポーネント追加
    add(Hud());

    // BGM
    BgmPlayer.setBgm(setting.bgm);
    BgmPlayer.setVolume(setting.bgmVolume);
  }

  /// 仮想キーの入力イベント受付
  void onVirtualKeyChanged(UserCommand userCommand) {
    // print('${userCommand}');
    userCommands.add(userCommand);
  }

  /// キーボードからの入力イベント受付
  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    // プレイヤーが移動中はキーイベントを無視
    if (_player.isMoving) return KeyEventResult.handled;

    // Undo,Redoのキー入力処理
    if (keysPressed.contains(LogicalKeyboardKey.digit1)) {
      userCommands.add(UserCommand.undo);
      return KeyEventResult.handled;
    } else if (keysPressed.contains(LogicalKeyboardKey.digit2)) {
      userCommands.add(UserCommand.redo);
      return KeyEventResult.handled;
    }

    if ((keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft))) {
      userCommands.add(UserCommand.moveLeft);
    }
    if ((keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight))) {
      userCommands.add(UserCommand.moveRight);
    }
    if ((keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp))) {
      userCommands.add(UserCommand.moveUp);
    }
    if ((keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown))) {
      userCommands.add(UserCommand.moveDown);
    }

    return KeyEventResult.handled;
  }

  // ダイアログ系オーバーレイ(メニュー、ステージクリア、設定)のいずれかがアクティブか
  bool get isOverlayDisplayed {
    return overlays.activeOverlays
        .where(
            (e) => (e == 'MainMenu' || e == 'StageClear' || e == 'SettingMenu'))
        .isNotEmpty;
  }

  /// ユーザーコマンドの実行
  void executeUserCommand() {
    var horizontalDirection = 0;
    var verticalDirection = 0;

    // ダイアログ系オーバーレイ(メニュー、ステージクリア、設定のいずれか)が出ている間は操作できない
    if (isOverlayDisplayed) return;

    // メニュー呼び出し(メニューのみプレイヤー移動中も受付)
    if (userCommands.firstOrNull == UserCommand.menu) {
      overlays.add('MainMenu');
    }

    // プレイヤーが移動中はメニュー以外のユーザーコマンドを無視
    if (_player.isMoving) return;

    while (userCommands.isNotEmpty) {
      var userCommand = userCommands.removeLast();
      switch (userCommand) {
        case UserCommand.undo:
          undo();
          return;
        case UserCommand.redo:
          redo();
          return;
        case UserCommand.moveLeft:
          horizontalDirection = -1;
          break;
        case UserCommand.moveRight:
          horizontalDirection = 1;
          break;
        case UserCommand.moveUp:
          verticalDirection = -1;
          break;
        case UserCommand.moveDown:
          verticalDirection = 1;
          break;
        default:
          break;
      }
    }
    userCommands = [];

    if (horizontalDirection.abs() + verticalDirection.abs() == 1) {
      playerMove(horizontalDirection, verticalDirection);
    }
  }

  /// プレイヤー移動
  void playerMove(int horizontalDirection, int verticalDirection) {
    IntVector2 gridMoveTo = _player.gridPosition +
        IntVector2(horizontalDirection, verticalDirection);
    var x = gridMoveTo.x;
    var y = gridMoveTo.y;
    IntVector2? crateNewPosition;
    var newBoard = Board.clone(board);

    // 移動可否の判定
    var oneStepAhead = board.boardData[y][x]; // 一歩先
    if (oneStepAhead == Tile.wall) return;
    // プレイヤーの先に荷物がある場合
    if (oneStepAhead == Tile.crate || oneStepAhead == Tile.crateAndGoal) {
      IntVector2 crateMoveTo =
          gridMoveTo + IntVector2(horizontalDirection, verticalDirection);
      var cx = crateMoveTo.x;
      var cy = crateMoveTo.y;
      var twoStepAhead = board.boardData[cy][cx]; // 二歩先
      // 荷物の移動先がゴールでも地面でもない時は動かせない
      if (twoStepAhead != Tile.goal && twoStepAhead != Tile.ground) return;

      // 荷物のスプライトを探す
      var crate = findCrate(gridMoveTo);
      if (crate == null) {
        resetCrateSprites();
      } else {
        // 荷物移動
        var onGoal = (twoStepAhead == Tile.goal); // 移動先がゴールか
        crate.moveTo(crateMoveTo, onGoal, () {});
      }

      // マップ更新
      newBoard.boardData[y][x] =
          (oneStepAhead == Tile.crateAndGoal ? Tile.goal : Tile.ground);
      newBoard.boardData[cy][cx] =
          (twoStepAhead == Tile.goal ? Tile.crateAndGoal : Tile.crate);
      crateNewPosition = IntVector2(cx, cy);
    }

    // プレイヤー位置更新
    playerPosition = gridMoveTo;
    _player.moveTo(gridMoveTo);

    // リプレイリスト更新
    if (gameSteps + 1 < replayList.length) {
      // 現在のgameStepがリプレイリストの途中であれば、gameStep以降のリプレイリストを破棄
      replayList.removeRange(gameSteps + 1, replayList.length);
    }
    replayList.add(ReplayData(newBoard, playerPosition, crateNewPosition));
    gameSteps++;
    board = newBoard;

    // デバッグ時のみ実行されます
    assert(() {
      stageViewer();
      return true; // assert()の戻り値はbool型で、trueを返します
    }());
  }

  /// 1手もどす(アンドゥ)
  void undo() {
    if (gameSteps <= 0) return; // step=0の時はundoできない
    gameSteps--;
    var currentReplayData = replayList[gameSteps];
    var nextReplayData = replayList[gameSteps + 1];
    board = currentReplayData.board;
    // プレイヤー移動
    playerPosition = currentReplayData.playerPos;
    _player.moveTo(playerPosition, isReverse: true, speedFactor: 0.5);
    // 荷物移動
    if (nextReplayData.cratePos != null) {
      var crate = findCrate(nextReplayData.cratePos!); // 次の手の
      if (crate == null) {
        resetCrateSprites();
      } else {
        crate.moveTo(
            nextReplayData.playerPos, isGoal(nextReplayData.playerPos), () {},
            speedFactor: 0.5);
      }
    }

    // デバッグ時のみ実行されます
    assert(() {
      stageViewer();
      return true; // assert()の戻り値はbool型で、trueを返します
    }());
  }

  /// 1手すすめる(リドゥ) - リプレイリストがある時だけ
  void redo() {
    if (replayList.length <= gameSteps + 1) return; // 次にリプレイデータがない時はredoできない
    gameSteps++;
    var currentReplayData = replayList[gameSteps];
    // var previousReplayData = replayList[gameStep - 1];
    board = currentReplayData.board;
    // プレイヤー移動
    playerPosition = currentReplayData.playerPos;
    _player.moveTo(playerPosition, speedFactor: 0.5);
    // 荷物移動
    if (currentReplayData.cratePos != null) {
      var crate =
          findCrate(currentReplayData.playerPos); // 1手前のプレイヤーの位置が荷物の元の位置
      if (crate == null) {
        resetCrateSprites();
      } else {
        crate.moveTo(currentReplayData.cratePos!,
            isGoal(currentReplayData.cratePos!), () {},
            speedFactor: 0.5);
      }
    }

    // デバッグ時のみ実行されます
    assert(() {
      stageViewer();
      return true; // assert()の戻り値はbool型で、trueを返します
    }());
  }

  /// 荷物のスプライトを探す
  Crate? findCrate(IntVector2 gridPosition) {
    return _crates.firstWhereOrNull(
      (element) =>
          element.gridPosition.x == gridPosition.x &&
          element.gridPosition.y == gridPosition.y,
    );
  }

  /// 荷物がゴール上にあるかの判定
  bool isGoal(IntVector2 pos) {
    var tile = board.boardData[pos.y][pos.x];
    return tile == Tile.goal || tile == Tile.crateAndGoal;
  }

  /// 荷物のスプライトをリセットし再作成
  void resetCrateSprites() {
    children.whereType<Crate>().map((e) => remove(e));
    _crates = [];

    var pos = IntVector2(0, 0);
    for (int j = 0; j < tileColumns; j++) {
      for (int i = 0; i < tileColumns; i++) {
        pos = IntVector2(i, j);
        switch (board.boardData[j][i]) {
          case Tile.crate:
            var crate = Crate(
              gridPosition: pos,
              isOnGoal: false,
            );
            _crates.add(crate);
            break;
          case Tile.crateAndGoal:
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

  /// ゲームのリセット
  void reset() async {
    exitGame();
    await initializeGame();
  }

  /// ゲーム終了
  void exitGame() {
    FlameAudio.bgm.audioPlayer.stop();
    FlameAudio.bgm.dispose();
  }

  /// ステージデータほかのデータ表示(デバッグ用)
  void stageViewer() {
    for (var s in getXsokobanString(board)) {
      print(s);
    }
    print('step=$gameSteps');
    print('player x,y=${playerPosition.x},${playerPosition.y}');
  }

  // ズーム＆スクロール関係 (初期化はInitializeGameの中で実施)

  void clampZoom() {
    camera.zoom = camera.zoom.clamp(0.05, 3.0);
  }

  static const zoomPerScrollUnit = 0.02;

  @override
  void onScroll(PointerScrollInfo info) {
    camera.zoom += info.scrollDelta.game.y.sign * zoomPerScrollUnit;
    clampZoom();
  }

  late double startZoom;

  @override
  void onScaleStart(info) {
    startZoom = camera.zoom;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final currentScale = info.scale.global;
    if (!currentScale.isIdentity()) {
      camera.zoom = startZoom * currentScale.y;
      clampZoom();
    } else {
      camera.translateBy(-info.delta.game);
      camera.snap();
    }
  }
}
