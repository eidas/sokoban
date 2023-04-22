import 'package:flutter/material.dart';

import 'package:sokoban/sokoban.dart';
import 'package:sokoban/helper/stage_data.dart';

class StageClear extends StatelessWidget {
  // Reference to parent game.
  final SokobanGame game;
  const StageClear({super.key, required this.game});
  final String stageClearOverlayKey = 'StageClear';

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);
    String? nextStageName = StageData.getNextStage(game.stageName);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
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
              Text(
                game.localizations.stageClearText,
                style: const TextStyle(
                  color: whiteTextColor,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 40),
              // NextStage ボタン
              SizedBox(
                width: 200,
                height: 75,
                child: ElevatedButton(
                  onPressed: nextStageName == null
                      ? null
                      : () {
                          Navigator.of(context)
                              .pushReplacementNamed('/gamepage', arguments: {
                            'stageName': nextStageName,
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteTextColor,
                  ),
                  child: Text(
                    game.localizations.nextStageText,
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
                    game.overlays.remove(stageClearOverlayKey);
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
      ),
    );
  }
}
