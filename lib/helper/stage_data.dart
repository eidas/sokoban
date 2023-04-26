import 'dart:convert';
import 'package:flutter/services.dart';

class StageData {
  static List<String>? _stageDataList;
  static bool _isComplete = false;
  static Future<List<String>> get stageDataList async {
    if (_stageDataList == null) {
      await _getStageDataListFromAssets();
    }
    return _stageDataList!;
  }

  static Future<void> _getStageDataListFromAssets() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final assetKeys = manifestMap.keys
        .where((String key) =>
            (key.endsWith('.dat') && key.contains('assets/stageData/')))
        .toList();

    _stageDataList = [];
    for (var assetKey in assetKeys) {
      final assetPath = assetKey.replaceAll('assets/stageData/', '');
      _stageDataList!.add(assetPath);
    }
    _isComplete = true;
  }

  static String? getNextStage(String stageName) {
    if (!_isComplete) return null;
    List<String> tmp = _stageDataList ?? [];
    int index = tmp.indexOf(stageName);
    if (index < 0) return null;
    return tmp.indexOf(stageName) + 1 < tmp.length
        ? tmp[tmp.indexOf(stageName) + 1]
        : null;
  }
}
