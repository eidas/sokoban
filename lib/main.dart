import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sokoban/pages/game_main.dart';
import 'package:sokoban/pages/title_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  // final game = SokobanGame();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja', ''), //日本語
        Locale('en', ''), //英語
      ],
      home: const Scaffold(
        body: TitlePage(),
      ),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => const TitlePage(),
        '/gamepage': (BuildContext context) => const GameMain(),
      }));
}
