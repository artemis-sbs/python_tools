import 'dart:io' as io;
import 'package:path/path.dart' as p;
import 'package:miss/context.dart';

Future<void> processDoctor(Context ctx) async {
  ctx.pythonDirExists = await io.File(ctx.pythonDir).exists();
  ctx.missionDirExists = await io.Directory(ctx.missionDir).exists();
  ctx.pipExists = await io.File(ctx.pipExe).exists();
  if (ctx.pythonDirExists) {
    ctx.cout.add('[*] $ctx.pythonExe exits');
  } else {
    ctx.cout.add('[ ] $ctx.pythonExe DOES NOT exits');
  }

  if (ctx.missionDirExists) {
    ctx.cout.add('[*] $ctx.missionDir exits');
  } else {
    ctx.cout.add('[ ] $ctx.missionDir DOES NOT exits');
  }

  if (ctx.pipExists) {
    ctx.cout.add('[*] $ctx.pipExe exits');
  } else {
    ctx.cout
        .add('[ ] $ctx.pipExe DOES NOT exits. Enter the command "fixpip" to fix.');
  }
}
