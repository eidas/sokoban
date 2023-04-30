import 'package:flutter/material.dart';
import 'package:sokoban/helper/setting.dart';

import 'package:sokoban/sokoban.dart';
import 'package:sokoban/constants.dart';
import 'package:sokoban/helper/bgm_player.dart';

const List<Widget> bgms = <Widget>[
  Text('Off'),
  Icon(Icons.shuffle),
  Text('1'),
  Text('2'),
  Text('3'),
];

class SettingsMenu extends StatefulWidget {
  // Reference to parent game.
  final SokobanGame game;

  const SettingsMenu({super.key, required this.game});

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  final String thisOverlayKey = Constants.settingsMenuOverlayKey;
  final List<bool> _selectedBgms = <bool>[false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);
    _selectedBgms[widget.game.setting.bgm.index] = true;

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Stack(alignment: Alignment.topRight, children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            height: 400,
            width: 400,
            decoration: const BoxDecoration(
              color: blackTextColor,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // BGM選択のトグルボタン
                Container(
                  width: 340,
                  decoration: BoxDecoration(
                    color: whiteTextColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        widget.game.localizations.bgmText,
                        style: const TextStyle(
                          fontSize: 30.0,
                          color: blackTextColor,
                        ),
                      ),
                      ToggleButtons(
                        direction: Axis.horizontal,
                        onPressed: (int index) {
                          setState(() {
                            // The button that is tapped is set to true, and the others to false.
                            for (int i = 0; i < _selectedBgms.length; i++) {
                              _selectedBgms[i] = i == index;
                            }
                            widget.game.setting.bgm = Bgm.values[index];
                            BgmPlayer.setBgm(widget.game.setting.bgm);
                          });
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        selectedBorderColor: Colors.grey,
                        selectedColor: whiteTextColor,
                        fillColor: Colors.black,
                        color: Colors.black,
                        constraints: const BoxConstraints(
                          minHeight: 40.0,
                          minWidth: 60.0,
                        ),
                        isSelected: _selectedBgms,
                        children: bgms,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // ボリュームスライダー
                Container(
                  width: 340,
                  decoration: BoxDecoration(
                    color: whiteTextColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        widget.game.localizations.volumeText(
                            widget.game.setting.bgmVolume.toStringAsFixed(2)),
                        // 'Volume: ${widget.game.setting.bgmVolume.toStringAsFixed(2)}', // Sliderの値を表示
                        style: const TextStyle(
                          fontSize: 30.0,
                          color: blackTextColor,
                        ),
                      ),
                      Slider(
                        value: widget.game.setting.bgmVolume, // 値を指定
                        onChanged: (value) {
                          // 変更した値を代入
                          setState(() {
                            widget.game.setting.bgmVolume = value;
                            BgmPlayer.setVolume(widget.game.setting.bgmVolume);
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
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
                widget.game.overlays.remove(thisOverlayKey);
              },
              splashRadius: 0.1,
            ),
          ),
        ]),
      ),
    );
  }
}
