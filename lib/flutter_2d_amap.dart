import 'dart:async';

import 'package:flutter/services.dart';
export 'src/amap_2d_view.dart';
export 'src/poisearch_model.dart';

class Flutter2dAMap {
  static const MethodChannel _channel = const MethodChannel('plugins.weilu/flutter_2d_amap_');

  static Future<bool> setApiKey(String key) async {
    return await _channel.invokeMethod("setKey", key);
  }
}
