import 'package:flame/components.dart';

import 'package:sokoban/sokoban.dart';
import 'package:sokoban/constants.dart';
import 'package:sokoban/utils/int_vector2.dart';

class GridObject extends SpriteComponent with HasGameRef<SokobanGame> {
  GridObject({
    required this.gridPosition,
    this.xOffset = 0.0,
    this.yOffset = 0.0,
    required this.imageFileName,
    this.imageTileRow = 0,
    this.imageTileColumn = 0,
  }) : super(size: Vector2.all(Constants.tileSize), anchor: Constants.anchor);

  IntVector2 gridPosition;
  double xOffset;
  double yOffset;

  String imageFileName;
  int imageTileRow;
  int imageTileColumn;

  @override
  Future<void> onLoad() async {
    final img = game.images.fromCache(imageFileName);
    sprite = Sprite(img,
        srcPosition: Vector2(imageTileColumn * Constants.tileSize,
            imageTileRow * Constants.tileSize),
        srcSize: Vector2(Constants.tileSize, Constants.tileSize));
    position = Vector2(
      (gridPosition.x * size.x) + xOffset + (Constants.tileSize / 2),
      (gridPosition.y * size.y) + yOffset + (Constants.tileSize / 2),
    );
  }
}
