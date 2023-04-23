import 'package:flutter/material.dart';

import 'package:sokoban/sokoban.dart';

class MainMenu extends StatelessWidget {
  // Reference to parent game.
  final SokobanGame game;

  const MainMenu({super.key, required this.game});
  final String mainMenuOverlayKey = 'MainMenu';

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Stack(alignment: Alignment.topRight, children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            height: 400,
            width: 300,
            decoration: const BoxDecoration(
              color: blackTextColor,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // retryボタン
                SizedBox(
                  width: 200,
                  height: 75,
                  child: ElevatedButton(
                    onPressed: () {
                      game.overlays.remove(mainMenuOverlayKey);
                      Navigator.of(context)
                          .pushReplacementNamed('/gamepage', arguments: {
                        'stageName': game.stageName,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: whiteTextColor,
                    ),
                    child: Text(
                      game.localizations.retryText,
                      style: const TextStyle(
                        fontSize: 28.0,
                        color: blackTextColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // BackToTitle ボタン
                SizedBox(
                  width: 200,
                  height: 75,
                  child: ElevatedButton(
                    onPressed: () {
                      game.overlays.remove(mainMenuOverlayKey);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: whiteTextColor,
                    ),
                    child: Text(
                      game.localizations.backToTitleText,
                      style: const TextStyle(
                        fontSize: 28.0,
                        color: blackTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.black,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                game.overlays.remove('MainMenu');
              },
              splashRadius: 0.1,
            ),
          ),
        ]),
      ),
    );
  }
}
