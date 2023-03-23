import 'package:sokoban/objects/grid_object.dart';
import 'package:sokoban/utils/int_vector2.dart';

class Ground extends GridObject {
  Ground({
    required IntVector2 gridPosition,
    double xOffset = 0,
    double yOffset = 0,
  }) : super(
          gridPosition: gridPosition,
          xOffset: xOffset,
          yOffset: yOffset,
          imageFileName: 'ground.png',
          imageTileRow: 1,
        );
}
