import 'dart:convert';

import 'package:miss/context.dart';
import 'package:miss/install.dart';
import "package:path/path.dart" as p;
import 'dart:io';

import 'package:miss/web.dart';

String batch = r"""
REM @echo off
 @cd /D "%~dp0"
 curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py
 .\PyRuntime\python get-pip.py
 if exist get-pip.py (
     del get-pip.py
 )
""";

String help = """
# Adding PIP to Artemis Cosmos
Artemis Cosmos does not ship with PIP the a tool to manage dependcies.

PIP can be added using the batch file dispayed below.

By pressing the 'Fix PIP' button this will be run adding pip to Artemis Cosmos.

This is only need to be run once for a Artemis Cosoms install.

Alternatively you can copy the batch file, or run the commands yourself.

``` bat
$batch
```
""";

Future<void> processFixPipBatch(Context ctx) async {
  var batchFile = p.join(ctx.basedir, 'pip_install.bat');
  runBatch(ctx, batchFile, ctx.basedir, true);
}
/*
Future<void> processFixPip(Context ctx) async {
  var url = "https://bootstrap.pypa.io/get-pip.py";
  var script = p.join(ctx.basedir, 'PyRuntime', 'get-pip.py');
  var python = p.join(ctx.basedir, 'PyRuntime', 'python.exe');
  var backup = p.join(ctx.basedir, 'PyRuntime', 'python310._pth.rename');
  var fixPath = p.join(ctx.basedir, 'PyRuntime', 'python310._pth');

  if (await fetchUrl(url, script)) {
    ctx.cout.add('Retreived pip install script');
  } else {
    ctx.cout.add('Failed to retreive pip install script');
    return;
  }
  final args = <String>[script];
  final process = await Process.start(python, args);
  await ctx.cout.addStream(process.stdout.transform(utf8.decoder));
  await ctx.cerr.addStream(process.stderr.transform(utf8.decoder));
  final exitCode = await process.exitCode;
  if (exitCode == 0) {
    // Remove the defined path file
    var bck = File(backup);
    if (await bck.exists()) {
      await bck.delete();
    }
    var pth = File(fixPath);
    if (await pth.exists()) {
      await pth.rename(backup);
    }
    var scr = File(script);
    if (await scr.exists()) {
      await scr.delete();
    }

    ctx.cout.add('Done');
  } else {
    ctx.cout.add('failed');
  }
}
*/