import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:typed_data';

Widget _buildImageFromEncodedData(String encodedImage,
    {double width, double height}) {
  if (encodedImage == null || encodedImage.isEmpty) {
    // 이미지가 없을 때 플레이스홀더 이미지 표시
    return Container(
      width: width,
      height: height,
      color: Colors.grey, // 또는 로딩 중을 나타내는 다른 UI 요소
    );
  }

  Uint8List imageBytes = base64.decode(encodedImage);
  ImageProvider imageProvider = MemoryImage(imageBytes);

  return Container(
    width: width,
    height: height,
    child: Image(
      image: imageProvider,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        // 로딩 진행 상태 표시
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes
                : null,
          ),
        );
      },
    ),
  );
}
