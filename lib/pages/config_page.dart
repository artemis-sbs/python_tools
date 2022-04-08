import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:miss/context.dart';
import 'package:miss/doctor.dart';
import 'package:miss/fixpip.dart';

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
  Container checkup(bool state, String good, String bad) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
         children: [
          if (state) ...[
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 30.0,
            ),
            Text(good)
          ] else ...[
            Icon(
              Icons.cancel,
              color: Colors.red,
              size: 30.0,
            ),
            Text(bad)
          ]
        ],
      ),
    );
  }

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
            Text('Directory: ${widget.ctx.basedir}'),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                checkup(
                    widget.ctx.missionDirExists,
                    "The Mission Directory Exists",
                    "No mission directory. Set in settings.yaml or run in an Artemis Cosmos directory."),
                checkup(widget.ctx.pythonDirExists, "Python exists.",
                    "No mission directory. Set in settings.yaml or run in an Artemis Cosmos directory."),
                checkup(widget.ctx.pipExists, " PIP installed",
                "No PIP found."),
              ],
            ),
            
            if (widget.ctx.pythonDirExists &&
                widget.ctx.missionDirExists &&
                !widget.ctx.pipExists)
              Row(
                children: [
                  Column(children: [
                    ElevatedButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(16.0),
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () async {
                        await processFixPipBatch(widget.ctx);
                        await processDoctor(widget.ctx);
                      },
                      child: const Text('Install PIP'),
                    ),
                    SizedBox(
                      
                       width: MediaQuery.of(context).size.width-30,
                       height: 300,
                        child: Markdown(
                          shrinkWrap: false, data: help)),
                  ]),
                ],
              ),
          ]),
    ));
  }
}
