import 'dart:async';

import 'package:flutter/material.dart';
import 'package:miss/context.dart';

Future<void> showLog(BuildContext context, Context ctx) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) => TextDisplay("directoryPath", ctx),
  );
}

/// Widget that displays a text file in a dialog
class TextDisplay extends StatelessWidget {
  /// Default Constructor
  const TextDisplay(this.directoryPath, this.ctx);

  /// Directory path
  final String directoryPath;
  final Context ctx;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Console log'),
      content: SizedBox(width: 640, height: 480,
        child: ConsoleLog(ctx: ctx)),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class ConsoleLog extends StatefulWidget {
  const ConsoleLog({
    Key? key,
    required this.ctx,
  }) : super(key: key);

  final Context ctx;
  @override
  State<ConsoleLog> createState() => _ConsoleLogState(ctx);
}

class _ConsoleLogState extends State<ConsoleLog> {
  final Context ctx;
  final List<String> _lines = [];
  late StreamSubscription<String> sub;

  _ConsoleLogState(this.ctx);
  @override
  void initState() {
    sub = ctx.cout.stream.listen((event) {
      setState(() {
        _lines.add(event);
      });
    });
    super.initState();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: _lines.length,
              itemBuilder: (context, index) {
                final String lineItem = _lines[index];
                return Container(child: Text(lineItem));
              })
          //})
        ],
      ),
    );
  }
}
