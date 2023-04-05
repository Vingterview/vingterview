import 'dart:io';
import 'package:http/http.dart' as http;

Future<String> uploadVideo(File videoFile) async {
  var stream = new http.ByteStream(videoFile.openRead());
  stream.cast();

  var uri = Uri.parse("https://example.com/upload");
  var request = new http.MultipartRequest("POST", uri);
  var multipartFile = new http.MultipartFile(
    'video',
    stream,
    videoFile.lengthSync(),
    filename: videoFile.path.split("/").last,
  );

  request.files.add(multipartFile);
  var response = await request.send();
  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);

  return responseString;
}
