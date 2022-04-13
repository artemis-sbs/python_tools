import 'dart:io';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:miss/install.dart';
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:miss/context.dart';
import 'package:miss/widgets/checkup.dart';

class DevPage extends StatefulWidget {
  const DevPage({Key? key, required this.ctx}) : super(key: key);
  final Context ctx;

  @override
  _DevPageState createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  final List<String> _lines = [];
  int? selectedIndex;
  bool require = false;
  bool pip = false;
  bool readme = false;

  final ScrollController listController = ScrollController();
  final ScrollController md1Controller = ScrollController();
  final ScrollController md2Controller = ScrollController();

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

  Future<bool> checkFile(String m, String f) async {
    String fn = path.join(widget.ctx.missionDir, m, f);
    return File(fn).exists();
  }

  Future<void> createFile(String m, String f, String text) async {
    String fn = path.join(widget.ctx.missionDir, m, f);
    File file = File(fn);
    await file.writeAsString(text);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      //mainAxisSize: MainAxisSize.max,
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: ListView(
            controller: listController,
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
                      onTap: () async {
                        readme = await checkFile(_lines[index], 'README.md');
                        pip = await checkFile(_lines[index], 'pip_install.bat');
                        require =
                            await checkFile(_lines[index], 'requirements.txt');

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
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Markdown(
                      controller: md1Controller,
                      key: UniqueKey(),
                      data: "Describe why")),
              Row(children: [
                checkup(readme, "README.md exists", "no README>md"),
                if (!readme)
                  ElevatedButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () async {
                      await createFile(_lines[selectedIndex!], "README.md",
                          "# Describe your mission");
                      readme =
                          await checkFile(_lines[selectedIndex!], 'README.md');
                      setState(() {});
                    },
                    child: const Text('Create readme'),
                  ),
              ]),
              Row(children: [
                checkup(
                    require, "requirements.txt exists", "no requirements.txt"),
                if (!require)
                  ElevatedButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () async {
                      await createFile(
                          _lines[selectedIndex!], "requirements.txt", "");
                      require = await checkFile(
                          _lines[selectedIndex!], "requirements.txt");
                      setState(() {});
                    },
                    child: const Text('Add requirements.txt'),
                  ),
              ]),
              if (require)
                Row(
                  children: [
                    checkup(
                        pip, "pip_install.bat exists", "no pip_install.bat"),
                    if (!pip)
                      ElevatedButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () async {
                          await createFile(_lines[selectedIndex!],
                              "pip_install.bat", batchFixPip);
                          pip = await checkFile(
                              _lines[selectedIndex!], "pip_install.bat");
                          setState(() {});
                        },
                        child: const Text('Add pip_install.bat'),
                      ),
                  ],
                ),
              if (pip)
                Row(
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
                    )
                  ],
                )
            ],
          ),
        ),
        Flexible(
            flex: 4,
            child: Markdown(
                controller: md2Controller,
                key: UniqueKey(),
                data: "The Read me is here"))
      ],
    );
  }
}
