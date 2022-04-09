import 'package:flutter/material.dart';
import 'package:miss/context.dart';
import 'package:miss/pages/config_page.dart';
import 'package:miss/pages/create_page.dart';
import 'package:miss/pages/dev_page.dart';
import 'package:miss/widgets/console_log.dart';

import 'package:miss/doctor.dart';

void main(List<String> arguments) {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Context ctx = Context();
  int _selectedIndex = 0;
  List<Widget> _pages = <Widget>[
    Text("Loading"),
    Text("Loading"),
    Text("Loading"),
    Text("Loading"),
  ];

  @override
  void initState() {
    ctx.basedir = r'F:\backup\artemis-3\Art3.0.0.13';
    ctx.load().then((_) {
      processDoctor(ctx).then((value) => setState(() {
            _pages = [
              ConfigPage(ctx: ctx),
              CreatePage( key: UniqueKey(), ctx: ctx, file: 'settings/dlc.yaml', help: 'Dlc'),
              CreatePage( key: UniqueKey(),ctx: ctx, file: 'settings/starter.yaml', help: 'Starter'),
              DevPage(ctx: ctx),
            ];
          }));
    });
    super.initState();
  }

  ConfigPage buildSetup() {
    return ConfigPage(ctx: ctx);
    // Column(children: [
    //   ConfigPage(ctx: ctx),
    //   // ConsoleLog(ctx: ctx),
    // ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.teal,
            title: const Text('Artemis Mission Python tools')),
        body: Center(child: _pages.elementAt(_selectedIndex)),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.blueGrey,
          selectedItemColor: Colors.teal,
          iconSize: 32,
          currentIndex: _selectedIndex, //New
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.download_for_offline),
              label: 'DLC',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.create),
              label: 'Create',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.developer_mode),
              label: 'Dev',
            ),
          ],
        ),
      ),
    );
  }
}
