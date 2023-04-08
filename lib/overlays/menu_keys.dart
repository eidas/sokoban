import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sokoban/helper/user_command.dart';
import 'package:sokoban/sokoban.dart';

class MenuKeys extends StatefulWidget {
  // Reference to parent game.
  final SokobanGame game;

  final ValueChanged<UserCommand>? onMenuSelected;

  const MenuKeys({Key? key, required this.game, required this.onMenuSelected})
      : super(key: key);

  @override
  State<MenuKeys> createState() => _MenuKeysState();
}

class _MenuKeysState extends State<MenuKeys> {
  var userCommand = UserCommand.none;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 120,
      child: Column(
        children: [
          MenuKey(
            icons: Icons.menu,
            onTapDown: (det) {
              updateDirection(UserCommand.menu);
            },
            onTapUp: (dets) {
              updateDirection(UserCommand.none);
            },
            onLongPressDown: () {
              updateDirection(UserCommand.menu);
            },
            onLongPressEnd: (dets) {
              updateDirection(UserCommand.none);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MenuKey(
                icons: Icons.undo,
                onTapDown: (det) {
                  updateDirection(UserCommand.undo);
                },
                onTapUp: (dets) {
                  updateDirection(UserCommand.none);
                },
                onLongPressDown: () {
                  updateDirection(UserCommand.undo);
                },
                onLongPressEnd: (dets) {
                  updateDirection(UserCommand.none);
                },
              ),
              MenuKey(
                icons: Icons.redo,
                onTapDown: (det) {
                  updateDirection(UserCommand.redo);
                },
                onTapUp: (dets) {
                  updateDirection(UserCommand.none);
                },
                onLongPressDown: () {
                  updateDirection(UserCommand.redo);
                },
                onLongPressEnd: (dets) {
                  updateDirection(UserCommand.none);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void updateDirection(UserCommand newUserCommand) {
    userCommand = newUserCommand;
    widget.onMenuSelected!(userCommand);
  }
}

class MenuKey extends StatelessWidget {
  const MenuKey({
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
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icons,
          size: 42,
        ),
      ),
    );
  }
}
