import "dart:io";
import 'dart:convert';

import "package:path/path.dart" as p;

import 'package:miss/context.dart';

String batchFixPip = r"""
@cd /D "%~dp0"
@set pyRuntime=..\..\..\PyRuntime\
@set PY_PIP=%pyRuntime%Scripts
@set PIP=%pyRuntime%Scripts\pip.exe
@set PY_LIBS=%pyRuntime%\Lib;%pyRuntime%\Lib\site-packages
@set path=%pyRuntime%;%PATH%
@%PIP% install -r requirements.txt --target .\lib\
@if not exist .\lib\__init__.py (
    @copy NUL .\lib\__init__.py 
)
""";

Future<void> processInstallBatch(Context ctx, String? s) async {
  var missionPath = p.join(ctx.basedir, 'data', 'missions', s);
  var batchFile = p.join(missionPath, 'pip_install.bat');
  var reqFile = p.join(missionPath, 'requirements.txt');
  
  if (await File(reqFile).exists()) {
    await runBatch(ctx, batchFixPip, batchFile, [], false);
  }

}

Future<void> runBatch(Context ctx, String batch, String batchFile, List<String> args, bool cleanup) async {
  File f = File(batchFile);
  if (!await f.exists()) {
    await f.writeAsString(batch);
  }
  final process = await Process.start(batchFile, args);

  await ctx.cout.addStream(process.stdout.transform(utf8.decoder));
  await ctx.cerr.addStream(process.stderr.transform(utf8.decoder));
  final exitCode = await process.exitCode;
  if (exitCode == 0) {
    ctx.cout.add('Done');
  } else {
    ctx.cout.add('Some errors occured.');
  }
  if (cleanup && await f.exists()) {
    await f.delete();
  }
}
/*
Future<void> processInstall(Context ctx, String? s) async {
  var missionPath = p.join(ctx.basedir, 'data', 'missions', s);
  var missionLib = p.join(missionPath, 'lib');
  var missionReq = p.join(missionPath, 'requirements.txt');
  var pip = p.join(ctx.basedir, 'PyRuntime', 'Scripts', 'pip.exe');
  var pyPath = p.join(ctx.basedir, 'PyRuntime');

  final args = <String>["install", "-r", missionReq, "--target", missionLib];
  final process = await Process.start(pip, args, environment: {
    'PATH': pyPath,
    'PY_PIP': p.join(ctx.basedir, 'PyRuntime', 'Scripts'),
    'PY_LIBS':
        '${p.join(ctx.basedir, 'PyRuntime', 'Lib')};${p.join(ctx.basedir, 'PyRuntime', 'Lib', 'site-packages')}'
  });

  await ctx.cout.addStream(process.stdout.transform(utf8.decoder));
  await ctx.cerr.addStream(process.stderr.transform(utf8.decoder));
  final exitCode = await process.exitCode;
  if (exitCode == 0) {
    var init = p.join(missionLib, '__init__.py');
    var iFile = File(init);
    if (await iFile.exists() == false) {
      await iFile.writeAsString("");
    }
    ctx.cout.add('Done');
  }
}
*/