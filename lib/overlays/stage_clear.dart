import 'package:flutter/material.dart';

import 'package:sokoban/sokoban.dart';

class StageClear extends StatelessWidget {
  // Reference to parent game.
  final SokobanGame game;
  const StageClear({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 200,
          width: 300,
          decoration: const BoxDecoration(
            color: blackTextColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Stage Clear!',
                style: TextStyle(
                  color: whiteTextColor,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    game.reset();
                    game.overlays.remove('StageClear');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteTextColor,
                  ),
                  child: const Text(
                    'Play Again',
                    style: TextStyle(
                      fontSize: 28.0,
                      color: blackTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
