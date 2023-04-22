import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TitlePage extends StatelessWidget {
  const TitlePage({super.key});

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 500,
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
                AppLocalizations.of(context)!.title,
                style: const TextStyle(
                  color: whiteTextColor,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 40),
              // New Game Button
              SizedBox(
                width: 240,
                height: 75,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed("/gamepage"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteTextColor,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.newGameText,
                    style: const TextStyle(
                      fontSize: 30.0,
                      color: blackTextColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Select Stage Button
              SizedBox(
                width: 240,
                height: 75,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed("/selectpage"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteTextColor,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.selectStageText,
                    style: const TextStyle(
                      fontSize: 30.0,
                      color: blackTextColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.instructionText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: whiteTextColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
