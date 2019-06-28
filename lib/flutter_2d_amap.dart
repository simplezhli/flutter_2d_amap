import 'dart:async';

import 'package:flutter/services.dart';
export 'src/amap_2d_view.dart';
export 'src/poisearch_model.dart';

class Flutter2dAmap {
  static const MethodChannel _channel = const MethodChannel('plugins.weilu/flutter_2d_amap');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
