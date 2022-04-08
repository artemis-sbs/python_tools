import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import "package:flutter/services.dart" as s;
import 'package:yaml/yaml.dart';

class Context {
  String basedir = ".";
  StreamController<String> cout = StreamController.broadcast();
  StreamController<String> cerr = StreamController.broadcast();
  bool pythonDirExists = false;
  bool missionDirExists = false;
  bool pipExists = false;

  Context();
  Future<void> load() async {
    basedir = Directory.current.path;
    try {
      File file = File('settings/config.yaml');
      String yamlString = file.readAsStringSync();
      Map yaml = loadYaml(yamlString);
      cout.add(yaml.toString());
      if (yaml.containsKey('artemisDir')) {
        basedir = yaml['artemisDir'];
      }
    } catch (e) {
      basedir = Directory.current.path;
    }
  }
  String get pythonDir {
    return  path.join(basedir, 'PyRuntime', 'python.exe');
  }
  String get missionDir {
    return path.join(basedir, 'data', 'missions');
  }
  String get pipExe {
    
    return path.join(basedir, 'PyRuntime', 'Scripts', 'pip.exe');
  }
}
