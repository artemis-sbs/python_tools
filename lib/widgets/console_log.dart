
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:miss/context.dart';

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
