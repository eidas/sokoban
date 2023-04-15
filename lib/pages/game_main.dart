import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sokoban/overlays/stage_clear.dart';
import 'package:sokoban/overlays/main_menu.dart';
import 'package:sokoban/sokoban.dart';
import 'package:sokoban/overlays/navidatiion_keys.dart';
import 'package:sokoban/overlays/menu_keys.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations_en.dart';

class GameMain extends StatelessWidget {
  const GameMain({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return const InnerWidget();
  }
}

class InnerWidget extends StatelessWidget {
  const InnerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizationWrapper(context).appLocalizations;
    gameFactory() => SokobanGame(context, localizations, 1);
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
