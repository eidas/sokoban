import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sokoban/pages/game_main.dart';
import 'package:sokoban/pages/title_page.dart';
import 'package:sokoban/pages/select_stage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          '/selectpage': (BuildContext context) => const SelectStage(),
        });
  }
}
