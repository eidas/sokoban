import 'dart:convert';
// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sokoban/helper/stage_data.dart';

class SelectStage extends StatefulWidget {
  const SelectStage({Key? key}) : super(key: key);

  @override
  _SelectStageState createState() => _SelectStageState();
}

class _SelectStageState extends State<SelectStage> {
  late Future<List<String>> _fileListFuture;
  late List<String> _fileList;
  String? _selectedFile;
  // String? _nextFile;

  @override
  void initState() {
    super.initState();
    _fileListFuture = StageData.stageDataList;
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
                    Navigator.of(context)
                        .pushReplacementNamed('/gamepage', arguments: {
                      'stageName': _selectedFile,
                    });
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
}
