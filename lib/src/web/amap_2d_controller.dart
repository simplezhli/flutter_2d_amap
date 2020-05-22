
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';
import 'package:flutter_2d_amap/src/interface/amap_2d_controller.dart';
import 'package:flutter_2d_amap/src/web/amapjs.dart';

class AMap2DWebController extends AMap2DController {
  AMap2DWebController(this._aMap);

  AMap _aMap;

  /// city：cityName（中文或中文全拼）、cityCode均可
  @override
  Future<void> search(String keyWord, {city = ''}) async {
    return Future.value();
  }

  @override
  Future<void> move(String lat, String lon) async {
    _aMap.setCenter(LngLat(double.parse(lon), double.parse(lat)));
    return Future.value();
  }

  @override
  Future<void> location() async {
    
    return Future.value();
  }
}
