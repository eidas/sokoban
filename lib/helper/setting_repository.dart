import 'package:sokoban/helper/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingRepository {
  static void saveToStorage(Setting setting) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('bgm', setting.bgm.index);
    await prefs.setDouble('bgmVolume', setting.bgmVolume);
  }

  static Future<Setting> readFromStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Bgm bgm =
        Bgm.values.firstWhere((e) => e.index == (prefs.getInt('bgm') ?? 0));
    double bgmVolume = prefs.getDouble('bgmVolume') ?? 1.0;
    return Setting(bgm, bgmVolume);
  }
}
