import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'graph_plus_exporter_method_channel.dart';

abstract class GraphViewExporterPlatform extends PlatformInterface {
  GraphViewExporterPlatform() : super(token: _token);

  static final Object _token = Object();

  static GraphViewExporterPlatform _instance = MethodChannelGraphViewExporter();

  /// The default instance of [GraphViewExporterPlatform] to use.
  ///
  /// Defaults to [MethodChannelGraphViewExporter].
  static GraphViewExporterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GraphViewExporterPlatform] when
  /// they register themselves.
  static set instance(GraphViewExporterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future exportContentToClipboard(Uint8List bytes, String mediaType);
}
