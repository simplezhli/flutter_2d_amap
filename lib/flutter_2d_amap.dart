import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

export 'src/amap_2d_view.dart';
export 'src/interface/amap_2d_controller.dart';
export 'src/poisearch_model.dart';

class Flutter2dAMap {
  static const MethodChannel _channel = MethodChannel('plugins.weilu/flutter_2d_amap_');

  static Future<bool> setApiKey(String key) async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return await _channel.invokeMethod('setKey', key);
    } else {
      return Future.value(true);
    }
  }
}
