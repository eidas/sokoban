import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';

import 'package:sokoban/sokoban.dart';
import 'package:sokoban/constants.dart';
import 'package:sokoban/utils/int_vector2.dart';

class Player extends SpriteAnimationComponent
    with KeyboardHandler, HasGameRef<SokobanGame> {
  IntVector2 gridPosition;
  IntVector2 _gridPositionMoveTo;
  double xOffset;
  double yOffset;
  late Vector2 offset;
  bool isMoving = false;
  List<Sprite> spriteList = [];
  late SpriteAnimation downAnimation;
  late SpriteAnimation upAnimation;
  late SpriteAnimation leftAnimation;
  late SpriteAnimation rightAnimation;

  Player({
    required this.gridPosition,
    this.xOffset = 0,
    this.yOffset = 0,
  })  : _gridPositionMoveTo = gridPosition,
        super(size: Vector2.all(Constants.tileSize), anchor: Constants.anchor) {
    offset = Vector2(xOffset, yOffset) +
        Vector2(Constants.tileSize / 2, Constants.tileSize / 2);
  }

  Vector2 _gridToPixelPosition(IntVector2 vec2) =>
      vec2.vector2 * Constants.tileSize + offset;

  IntVector2 get gridPositionMoveTo => _gridPositionMoveTo;
  bool moveTo(IntVector2 value) {
    _gridPositionMoveTo = value;
    isMoving = true;
    // 移動アニメーション
    add(
      MoveEffect.to(
        _gridToPixelPosition(
            _gridPositionMoveTo), //_gridPositionMoveTo * Constants.tileSize + offset,
        EffectController(duration: 0.2),
        onComplete: () {
          // アニメーション完了時にisMovingほかを更新
          isMoving = false;
          gridPosition = _gridPositionMoveTo;
        },
      ),
    );
    return true;
  }

  @override
  Future<void> onLoad() async {
    // スプライトシートから1枚ずつスプライトを生成
    for (int i = 0; i < 12; i++) {
      spriteList.add(Sprite(game.images.fromCache('player.png'),
          srcPosition: Vector2((i % 3) * Constants.tileSize,
              (i / 3).floor() * Constants.tileSize),
          srcSize: Vector2(64, 64)));
    }
    // 下向き時のアニメーション
    downAnimation = SpriteAnimation([
      SpriteAnimationFrame(spriteList[0], 0.2),
      SpriteAnimationFrame(spriteList[1], 0.2),
      SpriteAnimationFrame(spriteList[0], 0.2),
      SpriteAnimationFrame(spriteList[2], 0.2),
    ], loop: true);
    // 上向き時のアニメーション
    upAnimation = SpriteAnimation([
      SpriteAnimationFrame(spriteList[0], 0.1),
      SpriteAnimationFrame(spriteList[1], 0.1),
      SpriteAnimationFrame(spriteList[0], 0.1),
      SpriteAnimationFrame(spriteList[2], 0.1),
    ], loop: true);
    // 左向き時のアニメーション
    leftAnimation = SpriteAnimation([
      SpriteAnimationFrame(spriteList[0], 0.1),
      SpriteAnimationFrame(spriteList[1], 0.1),
      SpriteAnimationFrame(spriteList[0], 0.1),
      SpriteAnimationFrame(spriteList[2], 0.1),
    ], loop: true);
    // 右向き時のアニメーション
    rightAnimation = SpriteAnimation([
      SpriteAnimationFrame(spriteList[0], 0.1),
      SpriteAnimationFrame(spriteList[1], 0.1),
      SpriteAnimationFrame(spriteList[0], 0.1),
      SpriteAnimationFrame(spriteList[2], 0.1),
    ], loop: true);

    position = _gridToPixelPosition(gridPosition);
    // animation = SpriteAnimation.fromFrameData(
    //   game.images.fromCache('player.png'),
    //   SpriteAnimationData.sequenced(
    //     amount: 3,
    //     textureSize: Vector2.all(64),
    //     stepTime: 0.3,
    //   ),
    // );
    animation = downAnimation;
  }
}
