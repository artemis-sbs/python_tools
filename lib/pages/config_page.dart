import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:miss/context.dart';
import 'package:miss/doctor.dart';
import 'package:miss/fixpip.dart';
import 'package:file_selector/file_selector.dart';
import 'package:miss/widgets/console_log.dart';
import 'package:miss/widgets/checkup.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({
    Key? key,
    required this.ctx,
  }) : super(key: key);

  final Context ctx;

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Directory: ${widget.ctx.basedir}'),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                    ),
                    child: const Text('Browse'),
                    onPressed: () async {
                      widget.ctx.basedir = await _getDirectoryPath(context) ??
                          widget.ctx.basedir;
                      await processDoctor(widget.ctx);
                      setState(() {});
                    }),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                checkup(
                    widget.ctx.missionDirExists,
                    "The Mission Directory Exists",
                    "No mission directory. Select an Artemis Cosmos directory."),
                checkup(widget.ctx.pythonDirExists, "Python exists.",
                    "No PyRuntime directory. Select an Artemis Cosmos directory."),
                checkup(
                    widget.ctx.pipExists, " PIP installed", "No PIP found."),
              ],
            ),
            if (widget.ctx.pythonDirExists &&
                widget.ctx.missionDirExists &&
                !widget.ctx.pipExists)
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(children: [
                        ElevatedButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(16.0),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () async {
                            showLog(context, widget.ctx);
                            await processFixPipBatch(widget.ctx);
                            await processDoctor(widget.ctx);
                            setState(() {});
                          },
                          child: const Text('Install PIP'),
                        ),
                        Expanded(child: Markdown(shrinkWrap: true, data: help)),
                      ]),
                    )
                  ],
                ),
              ),
          ]),
    ));
  }

  Future<String?> _getDirectoryPath(BuildContext context) async {
    const String confirmButtonText = 'Choose';
    return await getDirectoryPath(
      confirmButtonText: confirmButtonText,
    );
  }
}
