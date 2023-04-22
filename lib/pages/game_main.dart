import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sokoban/overlays/stage_clear.dart';
import 'package:sokoban/overlays/main_menu.dart';
import 'package:sokoban/sokoban.dart';
import 'package:sokoban/overlays/navidatiion_keys.dart';
import 'package:sokoban/overlays/menu_keys.dart';
import 'package:sokoban/helper/setting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';
import 'package:flame_audio/flame_audio.dart';

class GameMain extends StatefulWidget {
  const GameMain({
    super.key,
  });

  @override
  State<GameMain> createState() => _GameMainState();
}

class _GameMainState extends State<GameMain> {
  _GameMainState();

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    String stageName = '001.dat';
    String nextStageName = '';
    if (arguments != null && arguments is Map) {
      stageName = arguments['stageName'].toString();
      nextStageName = arguments['nextStageName'] ?? '';
    }

    final localizations = AppLocalizationWrapper(context).appLocalizations;
    final setting = Setting(false, 1);
    gameFactory() => SokobanGame(
          context,
          localizations,
          setting,
          stageName,
        );
    return GameWidget<SokobanGame>.controlled(
      gameFactory: gameFactory,
      overlayBuilderMap: {
        'MainMenu': (_, game) => MainMenu(game: game),
        'StageClear': (_, game) => StageClear(game: game),
        'NavigationKey': (_, game) => Align(
              alignment: Alignment.bottomLeft,
              child: NavigationKeys(
                game: game,
                onDirectionChanged: game.onVirtualKeyChanged,
              ),
            ),
        'MenuKey': (_, game) => Align(
              alignment: Alignment.bottomRight,
              child: MenuKeys(
                game: game,
                onMenuSelected: game.onVirtualKeyChanged,
              ),
            ),
      },
      initialActiveOverlays: const ['NavigationKey', 'MenuKey'],
    );
  }

  @override
  void dispose() {
    FlameAudio.bgm.audioPlayer.stop();
    FlameAudio.bgm.dispose();
    super.dispose();
  }
}

class AppLocalizationWrapper {
  late AppLocalizations appLocalizations;

  AppLocalizationWrapper(BuildContext context) {
    try {
      appLocalizations = AppLocalizations.of(context)!;
    } catch (e) {
      appLocalizations = AppLocalizationsEn();
    }
  }
}
