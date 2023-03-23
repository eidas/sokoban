// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart';

class IntVector2 {
  final int x;
  final int y;
  IntVector2(this.x, this.y);
  Vector2 get vector2 => Vector2(x.toDouble(), y.toDouble());
  operator +(IntVector2 p) => IntVector2(x + p.x, y + p.y);
  operator -(IntVector2 p) => IntVector2(x - p.x, y - p.y);
}
