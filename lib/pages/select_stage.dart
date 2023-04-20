import 'dart:convert';
// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectStage extends StatefulWidget {
  const SelectStage({Key? key}) : super(key: key);

  @override
  _SelectStageState createState() => _SelectStageState();
}

class _SelectStageState extends State<SelectStage> {
  late Future<List<String>> _fileListFuture;
  late List<String> _fileList;
  String? _selectedFile;

  @override
  void initState() {
    super.initState();
    // _fileListFuture = _getFileListFromStageData();
    _fileListFuture = getAllAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          AppLocalizations.of(context)!.selectStageText,
          style: const TextStyle(
            color: Colors.white, // 文字色を赤に設定
            // fontSize: 20.0, // フォントサイズを20に設定
            // fontWeight: FontWeight.bold, // フォントの太さを太字に設定
          ),
        ),
      ),
      body: FutureBuilder<List<String>>(
        future: _fileListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _fileList = snapshot.data!;
            return ListView.builder(
              itemCount: _fileList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_fileList[index]),
                  onTap: () {
                    setState(() {
                      _selectedFile = _fileList[index];
                    });
                    // Navigator.of(context).pop(_selectedFile);
                    Navigator.of(context).pushReplacementNamed('/gamepage',
                        arguments: _selectedFile);
                  },
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  // Future<List<String>> _getFileListFromStageData() async {
  //   int count = 1;
  //   List<String> fileList = [];
  //   while (true) {
  //     final filename = 'stage${count.toString().padLeft(3, '0')}.dat';
  //     final file = File('/assets/stageData/$filename');
  //     if (await file.exists()) {
  //       fileList.add(filename);
  //       count++;
  //     } else {
  //       break;
  //     }
  //   }
  //   return fileList;
  // }

  Future<List<String>> getAllAssets() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final assetKeys = manifestMap.keys
        .where((String key) =>
            (key.endsWith('.dat') && key.contains('assets/stageData/')))
        .toList();

    List<String> fileList = [];
    for (var assetKey in assetKeys) {
      final assetPath = assetKey.replaceAll('assets/stageData/', '');
      final assetContent = await rootBundle.loadString(assetKey);
      // アセットファイルの内容を処理する
      fileList.add(assetPath);
    }
    return fileList;
  }
}
