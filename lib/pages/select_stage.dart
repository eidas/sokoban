import 'dart:io';
import 'package:flutter/material.dart';

class SelectStageWidget extends StatefulWidget {
  const SelectStageWidget({Key? key}) : super(key: key);

  @override
  _SelectStageWidgetState createState() => _SelectStageWidgetState();
}

class _SelectStageWidgetState extends State<SelectStageWidget> {
  late Future<List<String>> _fileListFuture;
  late List<String> _fileList;
  String? _selectedFile;

  @override
  void initState() {
    super.initState();
    _fileListFuture = _getFileListFromStageData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a File'),
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
                    Navigator.of(context).pop(_selectedFile);
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

  Future<List<String>> _getFileListFromStageData() async {
    int count = 1;
    List<String> fileList = [];
    while (true) {
      final filename = 'stage.${count.toString().padLeft(3, '0')}.dat';
      final file = File('/assets/stageData/$filename');
      if (await file.exists()) {
        fileList.add(filename);
        count++;
      } else {
        break;
      }
    }
    return fileList;
  }
}
