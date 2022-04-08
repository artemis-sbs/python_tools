import 'package:miss/context.dart';
import 'package:miss/install.dart';
import "package:path/path.dart" as p;

Future<void> processFetchMission(
    Context ctx, String user, String repo, String? amission) async {
  String mission = amission ?? repo;

  String batch = """cd /d "%~dp0"
curl -L --max-redirs 5 https://github.com/$user/$repo/zipball/master/ --output mission.tgz 
mkdir $mission
tar -xzvf mission.tgz -C $mission --strip-components 1
""";
  var missionPath = p.join(ctx.basedir, 'data', 'missions', 'fetch.bat');

  runBatch(ctx, batch, missionPath, true);

  ctx.cout.add('Fetch $user $repo Called');
}
