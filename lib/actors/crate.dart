import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';

import 'package:sokoban/sokoban.dart';
import 'package:sokoban/constants.dart';
import 'package:sokoban/utils/int_vector2.dart';

class Crate extends SpriteAnimationComponent
    with KeyboardHandler, HasGameRef<SokobanGame> {
  IntVector2 gridPosition;
  IntVector2 _gridPositionMoveTo;
  double xOffset;
  double yOffset;
  Vector2 offset = Vector2(0, 0);
  bool isMoving = false;
  bool isOnGoal = false;

  ColorEffect? colorEffect;

  Crate({
    required this.gridPosition,
    this.xOffset = 0,
    this.yOffset = 0,
    required this.isOnGoal,
  })  : _gridPositionMoveTo = gridPosition,
        super(size: Vector2.all(Constants.tileSize), anchor: Constants.anchor) {
    offset = Vector2(xOffset, yOffset) +
        Vector2(Constants.tileSize / 2, Constants.tileSize / 2);
  }

  Vector2 _gridToPixelPosition(IntVector2 vec2) =>
      vec2.vector2 * Constants.tileSize + offset;

  IntVector2 get gridPositionMoveTo => _gridPositionMoveTo;

  bool moveTo(
    IntVector2 value,
    bool isOnGoal,
    Function? callback, {
    double speedFactor = 1.0,
  }) {
    _gridPositionMoveTo = value;
    isMoving = true;
    // 移動アニメーション
    add(
      MoveEffect.to(
        _gridToPixelPosition(
            _gridPositionMoveTo), //_gridPositionMoveTo * Constants.tileSize + offset,
        EffectController(duration: Constants.defaultMoveTime * speedFactor),
        onComplete: () {
          // アニメーション完了時にisMovingほかを更新
          isMoving = false;
          gridPosition = _gridPositionMoveTo;

          if (callback != null) callback();
        },
      ),
    );
    if (isOnGoal) {
      addColorEffect();
    } else {
      removeColorEffect();
    }
    return true;
  }

  @override
  Future<void> onLoad() async {
    position = _gridToPixelPosition(gridPosition);
    priority = 1;
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('crate.png'),
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2.all(64),
        stepTime: 0.3,
      ),
    );
    if (isOnGoal) {
      addColorEffect();
    }
  }

  EffectController? effectController;
  void addColorEffect() {
    colorEffect = ColorEffect(
      const Color.fromARGB(255, 255, 255, 255),
      const Offset(0.0, 1.0),
      EffectController(duration: 1.2, reverseDuration: 1.2, infinite: true),
    );
    add(colorEffect!);
  }

  void removeColorEffect() {
    // Effect自体は終わってもnullにならないが、そのままremoveするとFlameの中でエラーになる
    // Effectがあるかどうかを調べる方法がわからなかったので、終了したEffectは自身でnullにして、
    // nullでない時だけremoveするようにした。
    if (colorEffect != null) remove(colorEffect!);
    colorEffect = ColorEffect(
        const Color.fromARGB(0, 0, 0, 0),
        const Offset(0.0, 0.0),
        EffectController(duration: 0.1), onComplete: () {
      colorEffect = null; // Effect自体が終了してもnullにならないようなので自身でnullにしている
    });
    add(colorEffect!);
  }
}
