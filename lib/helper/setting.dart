enum Bgm {
  off,
  shuffle,
  bgm1,
  bgm2,
  bgm3,
}

class Setting {
  Bgm bgm;
  double bgmVolume;

  Setting(this.bgm, this.bgmVolume);

  Setting.clone(Setting setting)
      : bgm = setting.bgm,
        bgmVolume = setting.bgmVolume;
}
