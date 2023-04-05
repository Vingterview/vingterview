import 'dart:typed_data';
import 'package:http/http.dart' as http;

class MyImageClass {
  Uint8List imageBytes;

  Future<void> loadImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      imageBytes = response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }
}
