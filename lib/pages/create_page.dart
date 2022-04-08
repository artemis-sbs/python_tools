import 'dart:io';

import 'package:flutter/material.dart';
import 'package:miss/fetch.dart';
import 'package:yaml/yaml.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import "package:path/path.dart" as path;

import 'package:miss/context.dart';
import 'package:miss/web.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key, required this.ctx}) : super(key: key);
  final Context ctx;

  @override
  _CreatePageState createState() => _CreatePageState();
}

class CreateItem {
  String? source;
  String? user;
  String? repo;
  bool? readme;
  String? markdown;
  CreateItem({this.source, this.readme, this.repo, this.user, this.markdown});
}

class _CreatePageState extends State<CreatePage> {
  final List<CreateItem> _dlc = [];
  int? selectedIndex;
  String markdown = '';
  String _mission = '';
  String? get _errorText {
    final text = _controller.value.text;
     String dir = path.join(widget.ctx.missionDir,text);
     Directory d = Directory(dir);
     if (d.existsSync()) {
       return '$text Directory exists';
     }
    return null;
  }
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    File file = File('settings/dlc.yaml');

    String yamlString = file.readAsStringSync();
    Map yaml = loadYaml(yamlString);
    if (yaml.containsKey('sources')) {
      List l = yaml['sources'];
      for (var item in l) {
        CreateItem dlcitem = CreateItem(
            user: item['user'],
            source: item['source'],
            repo: item['repo'],
            readme: item['readme'],
            markdown: item['markdown']);
        _dlc.add(dlcitem);
      }
    }
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
                  itemCount: _dlc.length,
                  itemBuilder: (context, index) {
                    final String user = _dlc[index].user ?? '';
                    final String repo = _dlc[index].repo ?? '';
                    final String source = _dlc[index].source ?? '';
                    return ListTile(
                      title: Text(
                        '$user/$repo',
                        style: TextStyle(
                            color: selectedIndex == index
                                ? Colors.white
                                : Colors.black),
                      ),
                      subtitle: Text(
                        source,
                        style: TextStyle(
                            color: selectedIndex == index
                                ? Colors.white
                                : Colors.black),
                      ),
                      tileColor: selectedIndex == index ? Colors.teal : null,
                      onTap: () {
                        selectMission(index);
                      },
                    );
                  })
              //})
            ],
          ),
        ),
        Flexible(
            flex: 3,
            child: Column(children: [
              Flexible(
                  flex: 9,
                  child: Markdown(
                    //shrinkWrap: true,
                    //controller: controller,
                    selectable: false,
                    data: markdown,
                  )),
              Flexible(
                  child: ValueListenableBuilder(
                    valueListenable: _controller,
                    builder: (context, TextEditingValue value, __) {
                    return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                      child: TextField(
                        controller: _controller,
                          onChanged: (value) {
                            _mission = value;
                          },
                          decoration:
                              InputDecoration(
                                labelText: 'New Mission Name',
                                errorText: _errorText
                                ))),
                  ElevatedButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () async {
                      if (selectedIndex == null) {
                        return;
                      }
                      CreateItem item = _dlc[selectedIndex!];
                      if (item.user == null || item.repo == null) {
                        return;
                      }
                      String user = item.user!;
                      String repo = item.repo!;

                      await processFetchMission(
                          widget.ctx, user, repo, _mission);
                    },
                    child: const Text('Create'),
                  ),
                ],
                  );}),
        )])),
      ],
    );
  }

  Future<void> selectMission(int index) async {
    String new_markdown = _dlc[index].markdown ?? '';
    bool readme = _dlc[index].readme ?? false;
    if (_dlc[index].markdown == null &&
        readme &&
        _dlc[index].user != null &&
        _dlc[index].repo != null) {
      String user = _dlc[index].user!;
      String repo = _dlc[index].repo!;
      // https://raw.githubusercontent.com/$user/$repo/master/README.md
      new_markdown = await fetchUrlString(
          'https://raw.githubusercontent.com/$user/$repo/master/README.md');
    }
    setState(() {
      selectedIndex = index;
      markdown = new_markdown;
    });
  }
}
