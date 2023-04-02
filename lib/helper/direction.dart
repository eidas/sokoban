enum Direction { up, down, left, right, none }

// Directionの逆方向を返すenum拡張
extension DirectionExt on Direction {
  Direction get oppositeSide {
    switch (this) {
      case Direction.down:
        return Direction.up;
      case Direction.up:
        return Direction.down;
      case Direction.left:
        return Direction.right;
      case Direction.right:
        return Direction.left;
      default:
        return Direction.none;
    }
  }
}
