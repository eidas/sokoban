// 面データのファイル形式は標準的なXsokoban形式に準拠する
/*
＊ マップの表記法
Xsokoban形式
床:    	      空白
壁:	          #
人:	          @
荷物:	        $
ゴール:	      .
人＋ゴール:	  +
荷物＋ゴール:	*
*/
const List<String> stageDataStr = [
  r'########',
  r'#.   @ #',
  r'#    $ #',
  r'#$##   #',
  r'# ##$ .#',
  r'#    ###',
  r'#   .###',
  r'########',
];

// 面データを内部で持つ持ち方は以下のとおり
/* List<List<int>> stageData
0: 未定義
1: 床(Ground)
2: 壁(Wall)
3: ゴール(Goal)
4: 荷物(Crate)
5: 荷物＋ゴール(Crate+Goal)
*/
enum Tile {
  None,
  Ground,
  Wall,
  Goal,
  Crate,
  CrateAndGoal,
}

int playerX = 0;
int playerY = 0;
int tileColumns = 0;
int tileRows = 0;
late int goals;
List<List<Tile>> stageData = [];
void readStageData() {
  goals = 0;
  int maxRows = stageDataStr.length;
  int maxColumns = stageDataStr
      .map((e) => e.length)
      .reduce((value, element) => value > element ? value : element);
  tileColumns = maxColumns;
  tileRows = maxRows;
  stageData = List.generate(
      maxRows, (j) => List.generate(maxColumns, (i) => Tile.None));
  for (int j = 0; j < maxRows; j++) {
    for (int i = 0; i < stageDataStr[j].length; i++) {
      var chr = stageDataStr[j][i];
      switch (chr) {
        case ' ': // Ground
          stageData[j][i] = Tile.Ground;
          break;
        case '#': // Block
          stageData[j][i] = Tile.Wall;
          break;
        case '.': // Goal
          stageData[j][i] = Tile.Goal;
          goals++;
          break;
        case '@': // Player
          stageData[j][i] = Tile.Ground;
          playerX = i;
          playerY = j;
          break;
        case r'$': // Crate
          stageData[j][i] = Tile.Crate;
          break;
        case '*': // Crate + Goal
          stageData[j][i] = Tile.CrateAndGoal;
          goals++;
          break;
        case '+': // Player + Goal
          stageData[j][i] = Tile.Goal;
          playerX = i;
          playerY = j;
          goals++;
          break;
        default:
          break;
      }
    }
  }
}

bool judgeStageClear() {
  int countOfCrateAndGoal = 0;
  for (int j = 0; j < tileRows; j++) {
    for (int i = 0; i < tileColumns; i++) {
      countOfCrateAndGoal += (stageData[j][i] == Tile.CrateAndGoal) ? 1 : 0;
    }
  }
  return countOfCrateAndGoal == goals;
}
