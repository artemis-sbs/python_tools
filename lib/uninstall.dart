import 'package:miss/context.dart';

Future<void> processUninstall(Context ctx, String? s) async {
  ctx.cout.add('Uninstall $s Called');
}
