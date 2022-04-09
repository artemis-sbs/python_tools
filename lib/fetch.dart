import 'package:miss/context.dart';
import 'package:miss/install.dart';
import "package:path/path.dart" as p;

String batch = """
cd /d "%~dp0"
set USER=%~1
set REPO=%~2
if "%~3" == "" (
  set MISSION=%~2
) else (
  set MISSION=%~3
)

curl -L --max-redirs 5 "https://github.com/%USER%/%REPO%/zipball/master/" --output mission.tgz 
mkdir "%MISSION%"
tar -xzvf mission.tgz -C "%MISSION%" --strip-components 1
if exist mission.tgz (
  del mission.tgz
)
""";

Future<void> processFetchMission(
    Context ctx, String user, String repo, String? amission) async {
  String mission = amission ?? repo;

  var missionPath = p.join(ctx.basedir, 'data', 'missions', 'fetch.bat');

  runBatch(ctx, batch, missionPath, [user, repo, mission], true);
}
