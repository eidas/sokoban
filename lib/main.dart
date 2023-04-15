import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sokoban/pages/game_main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  // final game = SokobanGame();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      Locale('ja', ''), //日本語
      Locale('en', ''), //英語
    ],
    home: Scaffold(
      body: GameMain(),
    ),
  ));
}
