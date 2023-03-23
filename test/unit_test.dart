import 'package:flutter_test/flutter_test.dart';
import 'package:sokoban/utils/int_vector2.dart';

void main() {
  test('unit Test', () {
    var vecA = IntVector2(3, 7);
    var vecB = IntVector2(1, 4);
    expect((vecA + vecB).x, 4);
    expect((vecA + vecB).y, 11);
    expect((vecA - vecB).x, 2);
    expect((vecA - vecB).y, 3);
    expect((vecB - vecA).x, -2);
    expect((vecB - vecA).y, -3);
  });
}
