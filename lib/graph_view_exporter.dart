import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart' as material;
import 'package:flutter/rendering.dart';

import 'graph_view_exporter_platform_interface.dart';

abstract class NamedMediaType {
  String get mediaType;
}

enum MediaType implements NamedMediaType {
  png("image/png");

  const MediaType(this.mediaType);

  @override
  final String mediaType;
}

class GraphViewExporter {
  Future exportImageToClipboard(Image image, NamedMediaType mediaType) async {
    final bytes = await _imageToByteData(image, mediaType);
    return GraphViewExporterPlatform.instance.exportContentToClipboard(
        bytes.buffer.asUint8List(), mediaType.mediaType);
  }

  Future exportWidgetToClipboard(
      material.GlobalKey key, NamedMediaType mediaType,
      {double pixelRatio = 1}) async {
    if (key.currentContext case material.BuildContext context) {
      if (context.findRenderObject() case RenderRepaintBoundary boundary) {
        final image = await boundary.toImage(pixelRatio: pixelRatio);
        await exportImageToClipboard(image, mediaType);
      } else {
        throw Exception(
            "The widget from the specified key is not a RepaintBoundary.");
      }
    } else {
      throw Exception("The specified key does not have a context");
    }
  }

  Future<ByteData> _imageToByteData(
      Image image, NamedMediaType mediaType) async {
    final bytes = switch (mediaType.mediaType) {
      "image/png" => await image.toByteData(format: ImageByteFormat.png),
      _ => throw Exception(
          "The specified media type '${mediaType.mediaType}' is not supported.")
    };

    if (bytes == null) {
      throw Exception("The image did not contain any byte data.");
    }

    return bytes;
  }
}
