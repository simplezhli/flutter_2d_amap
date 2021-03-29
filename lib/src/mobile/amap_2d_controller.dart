
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';
import 'package:flutter_2d_amap/src/interface/amap_2d_controller.dart';

class AMap2DMobileController extends AMap2DController {
  AMap2DMobileController(
      int id,
      this._widget,
      ) : _channel = MethodChannel('plugins.weilu/flutter_2d_amap_$id') {
    _channel.setMethodCallHandler(_handleMethod);
  }
  final MethodChannel _channel;

  final AMap2DView _widget;

  Future<dynamic> _handleMethod(MethodCall call) async {
    final String method = call.method;
    switch(method) {
      case 'poiSearchResult':
        {
          if (_widget.onPoiSearched != null) {
            final Map args = call.arguments as Map<dynamic, dynamic>;
            final List<PoiSearch> list = [];
            (json.decode(args['poiSearchResult'] as String) as List).forEach((dynamic value) {
              list.add(PoiSearch.fromJsonMap(value as Map<String, dynamic>));
            });
            _widget.onPoiSearched!(list);
          }
          return Future<dynamic>.value('');
        }
    }
    return Future<dynamic>.value('');
  }

  /// city：cityName（中文或中文全拼）、cityCode均可
  @override
  Future<void> search(String keyWord, {String city = ''}) async {
    return _channel.invokeMethod('search', <String, dynamic>{
      'keyWord': keyWord,
      'city': city,
    });
  }

  @override
  Future<void> move(String lat, String lon) async {
    return _channel.invokeMethod('move', <String, dynamic>{
      'lat': lat,
      'lon': lon
    });
  }

  @override
  Future<void> location() async {
    return _channel.invokeMethod('location');
  }
}
