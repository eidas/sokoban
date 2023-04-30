import 'dart:math';

import 'package:flame_audio/flame_audio.dart';
import 'package:sokoban/helper/setting.dart';

class BgmPlayer {
  static bool bgmPlayerInitialized = false;

  static List<String> audioFileNames = [
    'TEC07366OLK_TEC1.mp3',
    'TEC03619BXH_TEC1.mp3',
    'TEC07781BAG_TEC1.mp3',
  ];

  static Future<void> setBgm(Bgm bgm) async {
    FlameAudio.bgm.initialize();
    // if (!bgmPlayerInitialized) {
    //   FlameAudio.bgm.initialize();
    //   bgmPlayerInitialized = true;
    // }
    String audioFileName = audioFileNames[0];
    await FlameAudio.bgm.audioPlayer.stop();
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
    if (bgm == Bgm.off) return;
    switch (bgm) {
      case Bgm.bgm1:
        audioFileName = audioFileNames[0];
        break;
      case Bgm.bgm2:
        audioFileName = audioFileNames[1];
        break;
      case Bgm.bgm3:
        audioFileName = audioFileNames[2];
        break;
      case Bgm.shuffle:
        audioFileName = audioFileNames[Random().nextInt(audioFileNames.length)];
        break;
      default:
        audioFileName = audioFileNames[0];
        break;
    }
    await FlameAudio.bgm.play(audioFileName);
  }

  static Future<void> setVolume(double volume) async {
    FlameAudio.bgm.audioPlayer.setVolume(volume);
  }
}
