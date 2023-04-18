class Setting {
  final bool bgmOn;
  final double bgmVolume;

  Setting(this.bgmOn, this.bgmVolume);

  Setting.clone(Setting setting)
      : bgmOn = setting.bgmOn,
        bgmVolume = setting.bgmVolume;
}
