import 'package:flame/components.dart';

class Constants {
  // 画像関係
  static const double tileSize = 64.0;

  // スプライト関係
  static const Anchor anchor = Anchor.center;
  static const double defaultMoveTime = 0.2;

  // ナビゲーション関係(ページ名)

  // オーバーレイ名
  static const String mainMenuOverlayKey = 'MainMenu';
  static const String stageClearOverlayKey = 'StageClear';
  static const String navigationKeyOverlayKey = 'NavigationKey';
  static const String menuKeyOverlayKey = 'MenuKey';
  static const String settingsMenuOverlayKey = 'SettingsMenu';
}
