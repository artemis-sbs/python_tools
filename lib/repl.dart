import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:miss/context.dart';
import 'package:miss/add.dart' as add;
import 'package:miss/doctor.dart' as doctor;
import 'package:miss/fetch.dart' as fetch;
import 'package:miss/fixpip.dart' as fixpip;
import 'package:miss/install.dart' as install;
import 'package:miss/uninstall.dart' as uninstall;

Stream<String> readLine() =>
    stdin.transform(utf8.decoder).transform(const LineSplitter());
StreamSubscription<String>? rl;

void repl(Context ctx) {
  rl = readLine().listen((s) => processLine(ctx, s));
  ctx.cout.add('Say something');
}

void processExit(Context ctx) {
  rl?.cancel();
  ctx.cout.add('Exit Called');
}

Future<void> processLine(Context ctx, String input) async {
  final cmdFixpip = RegExp(r"^fix(p|pi|pip)?$");
  final cmdDoctor = RegExp(r"^doc(t|to|tor)?$");
  final cmdAdd = RegExp(r"^add\s+([\w\*\-]+)$");
  final cmdInstall = RegExp(r"^in(?:s|st|sta|stal|stall)?\s+([\w\*\-]+)$");
  final cmdUninstall =
      RegExp(r"^uni(?:n|ns|nst|nsta|nstal|nstall)?\s+([\w\*\-]+)$");
  final cmdFetch = RegExp(r"^fe(?:t|tc|tch)?\s+([\w\*\-]+)/([\w\*\-]+)$");
  final cmdExit = RegExp(r"^ex(i|it)?$");

  if (cmdExit.hasMatch(input)) {
    processExit(ctx);
  } else if (cmdFixpip.hasMatch(input)) {
    await fixpip.processFixPipBatch(ctx);
  } else if (cmdAdd.hasMatch(input)) {
    var m = cmdAdd.firstMatch(input);
    add.processAdd(ctx, m?.group(1));
  } else if (cmdFetch.hasMatch(input)) {
    var m = cmdFetch.firstMatch(input);
    await fetch.processFetchMission(
        ctx, m?.group(1) ?? '', m?.group(2) ?? '', null);
  } else if (cmdDoctor.hasMatch(input)) {
    doctor.processDoctor(ctx);
  } else if (cmdInstall.hasMatch(input)) {
    var m = cmdInstall.firstMatch(input);
    await install.processInstallBatch(ctx, m?.group(1));
  } else if (cmdUninstall.hasMatch(input)) {
    var m = cmdUninstall.firstMatch(input);
    await uninstall.processUninstall(ctx, m?.group(1));
  } else {
    ctx.cout.add('Invalid: $input');
  }
}
