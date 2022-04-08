import 'dart:io';
import 'package:miss/install.dart';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:miss/context.dart';

class DevPage extends StatefulWidget {
  const DevPage({Key? key, required this.ctx}) : super(key: key);
  final Context ctx;

  @override
  _DevPageState createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  final List<String> _lines = [];
  int? selectedIndex;
  @override
  void initState() {
    super.initState();
    initAsyncState();
  }

  Future<void> initAsyncState() async {
    _lines.clear();
    Directory d = Directory(widget.ctx.missionDir);
    await for (var m in d.list(recursive: false, followLinks: false)) {
      _lines.add(path.basename(m.path));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      //mainAxisSize: MainAxisSize.max,
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: ListView(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: _lines.length,
                  itemBuilder: (context, index) {
                    final String lineItem = _lines[index];
                    return ListTile(
                      title: Text(
                        lineItem,
                        style: TextStyle(
                            color: selectedIndex == index
                                ? Colors.white
                                : Colors.black),
                      ),
                      tileColor: selectedIndex == index ? Colors.teal : null,
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                    );
                  })
              //})
            ],
          ),
        ),
        Flexible(
          flex: 4,
          child: Column(
            children: [
              Flexible(
                child: Row(
                  children: [
                    ElevatedButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        if ((selectedIndex ?? -1) >= 0) {
                          String mission = _lines[selectedIndex!];
                          processInstallBatch(widget.ctx, mission);
                        }
                      },
                      child: const Text('PIP Install'),
                    ),ElevatedButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        if ((selectedIndex ?? -1) >= 0) {
                          String mission = _lines[selectedIndex!];
                          processInstallBatch(widget.ctx, mission);
                        }
                      },
                      child: const Text('Create requirements.txt'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
