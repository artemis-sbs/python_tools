import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<bool> fetchUrl(String url, String filepath) async {
  HttpClient client = HttpClient();
  client.autoUncompress = true;

  final HttpClientRequest request = await client.getUrl(Uri.parse(url));
  //request.headers
  //    .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
  request.followRedirects = true;
  final HttpClientResponse response = await request.close();
  if (response.statusCode == 200) {
    await response.pipe(File(filepath).openWrite());
    return true;
  }
  return false;
}

Future<String> fetchUrlString(String url) async {
  HttpClient client = HttpClient();
  client.autoUncompress = true;

  final HttpClientRequest request = await client.getUrl(Uri.parse(url));
  request.followRedirects = true;
  final HttpClientResponse response = await request.close();
  if (response.statusCode == 200) {
    final completer = Completer<String>();
    final contents = StringBuffer();
    response.transform(utf8.decoder).listen((event) {
      contents.write(event);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }
  return '<description not found>';
}
