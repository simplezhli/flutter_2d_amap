import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

export 'src/amap_2d_view.dart';
export 'src/interface/amap_2d_controller.dart';
export 'src/poi_search_model.dart';

class Flutter2dAMap {
  static const MethodChannel _channel = MethodChannel('plugins.weilu/flutter_2d_amap_');

  static String _webKey = '';
  static String get webKey => _webKey;

  static Future<bool?> setApiKey({String iOSKey = '', String webKey = ''}) async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _channel.invokeMethod<bool>('setKey', iOSKey);
    } else {
      if (kIsWeb) {
        _webKey = webKey;
      }
      return Future.value(true);
    }
  }
}
