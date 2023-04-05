import 'dart:io';
import 'package:http/http.dart' as http;

Future<String> uploadImage(File imageFile) async {
  var stream = new http.ByteStream(imageFile.openRead());
  stream.cast();

  var uri = Uri.parse("https://example.com/upload");
  var request = new http.MultipartRequest("POST", uri);
  var multipartFile = new http.MultipartFile(
    'image',
    stream,
    imageFile.lengthSync(),
    filename: imageFile.path.split("/").last,
  );

  request.files.add(multipartFile);
  var response = await request.send();
  var responseData = await response.stream.toBytes();
  var responseString = String.fromCharCodes(responseData);

  return responseString;
}
