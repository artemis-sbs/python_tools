import 'dart:io';
import 'dart:async';

import 'package:miss/repl.dart' as repl;
import 'package:miss/context.dart';

// [*] exit
// [*] fixpip
// [*] doctor
// [ ] fetch
// [ ] add
// [*] install
// [-] uninstall

void main(List<String> arguments) {
  
  Context ctx = Context();
  ctx.cout.stream.listen((event) {
    print(event);
  });
  ctx.cerr.stream.listen((event) {
    print(event);
  });

  ctx.basedir = r'F:\backup\artemis-3\Art3.0.0.13';
  repl.repl(ctx);
  //cout.add("hello, world");
}
