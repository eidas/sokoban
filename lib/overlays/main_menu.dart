import 'package:flutter/material.dart';

import 'package:sokoban/sokoban.dart';
import 'package:sokoban/constants.dart';

class MainMenu extends StatelessWidget {
  // Reference to parent game.
  final SokobanGame game;

  const MainMenu({super.key, required this.game});
  final String thisOverlayKey = Constants.mainMenuOverlayKey;

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
                // settingボタン
                SizedBox(
                  width: 240,
                  height: 75,
                  child: ElevatedButton(
                    onPressed: () {
                      game.overlays.add(Constants.settingsMenuOverlayKey);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: whiteTextColor,
                    ),
                    child: Text(
                      game.localizations.settingsText,
                      style: const TextStyle(
                        fontSize: 28.0,
                        color: blackTextColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // retryボタン
                SizedBox(
                  width: 240,
                  height: 75,
                  child: ElevatedButton(
                    onPressed: () {
                      game.overlays.remove(thisOverlayKey);
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
                  width: 240,
                  height: 75,
                  child: ElevatedButton(
                    onPressed: () {
                      game.overlays.remove(thisOverlayKey);
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
              icon: const Icon(Icons.close),
              onPressed: () {
                game.userCommands = [];
                game.overlays.remove(thisOverlayKey);
              },
              splashRadius: 0.1,
            ),
          ),
        ]),
      ),
    );
  }
}
