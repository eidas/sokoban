import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import 'package:sokoban/sokoban.dart';
import 'package:sokoban/constants.dart';
import 'package:sokoban/utils/int_vector2.dart';

class Crate extends SpriteAnimationComponent
    with KeyboardHandler, HasGameRef<SokobanGame> {
  IntVector2 gridPosition;
  IntVector2 _gridPositionMoveTo;
  double xOffset;
  double yOffset;
  late Vector2 offset;
  bool isMoving = false;

  Crate({
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

  bool moveTo(IntVector2 value, Function? callback) {
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
          if (callback != null) callback();
        },
      ),
    );
    return true;
  }

  @override
  Future<void> onLoad() async {
    position = _gridToPixelPosition(gridPosition);
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('crate.png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2.all(64),
        stepTime: 0.3,
      ),
    );
  }
}
