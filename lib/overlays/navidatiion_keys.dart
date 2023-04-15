import 'package:flutter/material.dart';
import 'package:sokoban/helper/user_command.dart';
import 'package:sokoban/sokoban.dart';

class NavigationKeys extends StatefulWidget {
  // Reference to parent game.
  final SokobanGame game;

  final ValueChanged<UserCommand>? onDirectionChanged;

  const NavigationKeys(
      {Key? key, required this.game, required this.onDirectionChanged})
      : super(key: key);

  @override
  State<NavigationKeys> createState() => _NavigationKeysState();
}

class _NavigationKeysState extends State<NavigationKeys> {
  UserCommand direction = UserCommand.none;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 120,
      child: Column(
        children: [
          ArrowKey(
            icons: Icons.keyboard_arrow_up,
            onTapDown: (det) {
              updateDirection(UserCommand.moveUp);
            },
            onTapUp: (dets) {
              updateDirection(UserCommand.none);
            },
            onLongPressDown: () {
              updateDirection(UserCommand.moveUp);
            },
            onLongPressEnd: (dets) {
              updateDirection(UserCommand.none);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ArrowKey(
                icons: Icons.keyboard_arrow_left,
                onTapDown: (det) {
                  updateDirection(UserCommand.moveLeft);
                },
                onTapUp: (dets) {
                  updateDirection(UserCommand.none);
                },
                onLongPressDown: () {
                  updateDirection(UserCommand.moveLeft);
                },
                onLongPressEnd: (dets) {
                  updateDirection(UserCommand.none);
                },
              ),
              ArrowKey(
                icons: Icons.keyboard_arrow_right,
                onTapDown: (det) {
                  updateDirection(UserCommand.moveRight);
                },
                onTapUp: (dets) {
                  updateDirection(UserCommand.none);
                },
                onLongPressDown: () {
                  updateDirection(UserCommand.moveRight);
                },
                onLongPressEnd: (dets) {
                  updateDirection(UserCommand.none);
                },
              ),
            ],
          ),
          ArrowKey(
            icons: Icons.keyboard_arrow_down,
            onTapDown: (det) {
              updateDirection(UserCommand.moveDown);
            },
            onTapUp: (dets) {
              updateDirection(UserCommand.none);
            },
            onLongPressDown: () {
              updateDirection(UserCommand.moveDown);
            },
            onLongPressEnd: (dets) {
              updateDirection(UserCommand.none);
            },
          ),
        ],
      ),
    );
  }

  void updateDirection(UserCommand newUserCommand) {
    direction = newUserCommand;
    widget.onDirectionChanged!(direction);
  }
}

class ArrowKey extends StatelessWidget {
  const ArrowKey({
    Key? key,
    required this.icons,
    required this.onTapDown,
    required this.onTapUp,
    required this.onLongPressDown,
    required this.onLongPressEnd,
  }) : super(key: key);
  final IconData icons;
  final Function(TapDownDetails) onTapDown;
  final Function(TapUpDetails) onTapUp;
  final Function() onLongPressDown;
  final Function(LongPressEndDetails) onLongPressEnd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onLongPress: onLongPressDown,
      onLongPressEnd: onLongPressEnd,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0x88ffffff),
          borderRadius: BorderRadius.circular(60),
        ),
        child: Icon(
          icons,
          size: 42,
        ),
      ),
    );
  }
}
