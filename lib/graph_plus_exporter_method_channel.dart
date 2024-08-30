import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'graph_view_exporter_platform_interface.dart';

/// An implementation of [GraphViewExporterPlatform] that uses method channels.
class MethodChannelGraphViewExporter extends GraphViewExporterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('archmind.io/graph_view_exporter');

  @override
  Future exportContentToClipboard(Uint8List bytes, String mediaType) async {
    await methodChannel
        .invokeMethod('exportContentToClipboard', <String, dynamic>{
      "bytes": bytes,
      "mediaType": mediaType,
    });
  }
}
