import 'package:flutter/services.dart';
import 'package:sokoban/utils/int_vector2.dart';

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
// const List<String> const_stageDataStr = [
//   r'########',
//   r'#.   @ #',
//   r'#    $ #',
//   r'#$#  . #',
//   r'# # $  #',
//   r'#     ##',
//   r'#   . ##',
//   r'########',
// ];

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
  none,
  ground,
  wall,
  goal,
  crate,
  crateAndGoal,
}

int playerX = 0;
int playerY = 0;
int tileColumns = 0;
int tileRows = 0;
int goals = 0;

class Board {
  List<List<Tile>> boardData = [];
  Board();
  Board.clone(Board copyingBoard) {
    for (var row in copyingBoard.boardData) {
      List<Tile> newRow = [];
      for (var col in row) {
        newRow.add(col);
      }
      boardData.add(newRow);
    }
  }
}

Board board = Board();

List<ReplayData> replayList = [];

class ReplayData {
//  final List<List<Tile>> board;
  final Board board;
  final IntVector2 playerPos;
  final IntVector2? cratePos;
  ReplayData(this.board, this.playerPos, this.cratePos);
}

// // ファイルからステージデータを読み込み
// Future<void> readStageDataFromFile(String filePath) async {
//   List<String> stageDataStr = [];
//   //ファイル読み込み処理
//   stageDataStr = await (File(filePath).readAsLines());
//   readStageData(stageDataStr);
// }

// Assetsからステージデータを読み込み
Future<void> loadAssetsStageDataTextFile(String filePath) async {
  final stageDataText = await rootBundle.loadString(filePath);
  List<String> stageDataStr = stageDataText.split(RegExp(r'\r?\n'));
  readStageData(stageDataStr);
}

// ステージデータの読み込み
void readStageData(List<String> stageDataStr) {
  goals = 0;
  int maxRows = stageDataStr.length;
  int maxColumns = stageDataStr
      .map((e) => e.length)
      .reduce((value, element) => value > element ? value : element);
  tileColumns = maxColumns;
  tileRows = maxRows;
  board.boardData = List.generate(
      maxRows, (j) => List.generate(maxColumns, (i) => Tile.none));
  for (int j = 0; j < maxRows; j++) {
    for (int i = 0; i < stageDataStr[j].length; i++) {
      var chr = stageDataStr[j][i];
      switch (chr) {
        case ' ': // Ground
          board.boardData[j][i] = Tile.ground;
          break;
        case '#': // Block
          board.boardData[j][i] = Tile.wall;
          break;
        case '.': // Goal
          board.boardData[j][i] = Tile.goal;
          goals++;
          break;
        case '@': // Player
          board.boardData[j][i] = Tile.ground;
          playerX = i;
          playerY = j;
          break;
        case r'$': // Crate
          board.boardData[j][i] = Tile.crate;
          break;
        case '*': // Crate + Goal
          board.boardData[j][i] = Tile.crateAndGoal;
          goals++;
          break;
        case '+': // Player + Goal
          board.boardData[j][i] = Tile.goal;
          playerX = i;
          playerY = j;
          goals++;
          break;
        default:
          break;
      }
    }
  }
  replayList.add(ReplayData(board, IntVector2(playerX, playerY), null));
}

// ステージクリア判定
bool judgeStageClear() {
  int countOfCrateAndGoal = 0;
  for (int j = 0; j < tileRows; j++) {
    for (int i = 0; i < tileColumns; i++) {
      countOfCrateAndGoal +=
          (board.boardData[j][i] == Tile.crateAndGoal) ? 1 : 0;
    }
  }
  return countOfCrateAndGoal == goals;
}

// ステージデータをXsokoban形式の文字列で返す
List<String> getXsokobanString(Board board) {
  List<String> xsokobanString = [];
  for (var row in board.boardData) {
    var rowString = '';
    for (var col in row) {
      switch (col) {
        case Tile.ground:
          rowString += ' ';
          break;
        case Tile.wall:
          rowString += '#';
          break;
        case Tile.goal:
          rowString += '.';
          break;
        case Tile.crate:
          rowString += '\$';
          break;
        case Tile.crateAndGoal:
          rowString += '*';
          break;
        default:
          rowString += ' ';
          break;
      }
    }
    xsokobanString.add(rowString);
  }
  return xsokobanString;
}
