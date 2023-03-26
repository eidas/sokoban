import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import 'package:sokoban/sokoban.dart';
import 'package:sokoban/constants.dart';
import 'package:sokoban/utils/int_vector2.dart';
import 'package:sokoban/helper/direction.dart';

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
    IntVector2 deltaVec = _gridPositionMoveTo - gridPosition;
    Direction direction = deltaVec.x.abs() > deltaVec.y.abs()
        ? (deltaVec.x > 0 ? Direction.right : Direction.left)
        : (deltaVec.y > 0 ? Direction.down : Direction.up);
    switch (direction) {
      case Direction.down:
        animation = downAnimation;
        break;
      case Direction.up:
        animation = upAnimation;
        break;
      case Direction.left:
        animation = leftAnimation;
        break;
      case Direction.right:
        animation = rightAnimation;
        break;
      case Direction.none:
        break;
    }
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
      SpriteAnimationFrame(spriteList[3], 0.2),
      SpriteAnimationFrame(spriteList[4], 0.2),
      SpriteAnimationFrame(spriteList[3], 0.2),
      SpriteAnimationFrame(spriteList[5], 0.2),
    ], loop: true);
    // 右向き時のアニメーション
    rightAnimation = SpriteAnimation([
      SpriteAnimationFrame(spriteList[6], 0.2),
      SpriteAnimationFrame(spriteList[7], 0.2),
      SpriteAnimationFrame(spriteList[6], 0.2),
      SpriteAnimationFrame(spriteList[8], 0.2),
    ], loop: true);
    // 左向き時のアニメーション
    leftAnimation = SpriteAnimation([
      SpriteAnimationFrame(spriteList[9], 0.2),
      SpriteAnimationFrame(spriteList[10], 0.2),
      SpriteAnimationFrame(spriteList[9], 0.2),
      SpriteAnimationFrame(spriteList[11], 0.2),
    ], loop: true);

    position = _gridToPixelPosition(gridPosition);
    animation = downAnimation;
  }
}
