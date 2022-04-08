import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:miss/context.dart';
import 'package:miss/web.dart';

class DlcPage extends StatefulWidget {
  const DlcPage({Key? key, required this.ctx}) : super(key: key);
  final Context ctx;

  @override
  _DlcPageState createState() => _DlcPageState();
}

class DlcItem {
  String? source;
  String? user;
  String? repo;
  bool? readme;
  String? markdown;
  DlcItem({this.source, this.readme, this.repo, this.user, this.markdown});
}

class _DlcPageState extends State<DlcPage> {
  final List<DlcItem> _dlc = [];
  int? selectedIndex;
  String markdown = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    File file = File('settings/dlc.yaml');

    String yamlString = file.readAsStringSync();
    Map yaml = loadYaml(yamlString);
    if (yaml.containsKey('sources')) {
      List l = yaml['sources'];
      for (var item in l) {
        DlcItem dlcitem = DlcItem(
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
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      //processInstall(widget.ctx, 'athread');
                    },
                    child: const Text('Install'),
                  ),
                ],
              )),
            ])),
      ],
    );
  }

  Future<void> selectMission(int index) async {
    String new_markdown = _dlc[index].markdown ?? '';
    bool readme = _dlc[index].readme ?? false;
    if (_dlc[index].markdown == null && readme) {
      String user = _dlc[index].user ?? '';
      String repo = _dlc[index].repo ?? '';
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
