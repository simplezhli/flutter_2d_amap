
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'poisearch_model.dart';

typedef void AMap2DViewCreatedCallback(AMap2DController controller);

class AMap2DView extends StatefulWidget {
  
  const AMap2DView({
    Key key,
    this.isPoiSearch: true,
    this.onPoiSearched,
    this.onAMap2DViewCreated
  }) :super(key: key);
  
  final bool isPoiSearch;
  final AMap2DViewCreatedCallback onAMap2DViewCreated;
  final Function(List<PoiSearch>) onPoiSearched;
  
  @override
  _AMap2DViewState createState() => _AMap2DViewState();
}

class _AMap2DViewState extends State<AMap2DView> {

  final Completer<AMap2DController> _controller = Completer<AMap2DController>();
  
  void _onPlatformViewCreated(int id) {
    final AMap2DController controller = AMap2DController._(id, widget);
    _controller.complete(controller);
    if (widget.onAMap2DViewCreated != null) {
      widget.onAMap2DViewCreated(controller);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'plugins.weilu/flutter_2d_amap',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: _CreationParams.fromWidget(widget).toMap(),
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'plugins.weilu/flutter_2d_amap',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: _CreationParams.fromWidget(widget).toMap(),
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Text('$defaultTargetPlatform is not yet supported by the flutter_2d_amap plugin');
  }
}

class AMap2DController{
  AMap2DController._(
      int id,
      this._widget,
      ) : _channel = MethodChannel('plugins.weilu/flutter_2d_amap_$id') {
    _channel.setMethodCallHandler(_handleMethod);
  }
  final MethodChannel _channel;

  AMap2DView _widget;

  Future<dynamic> _handleMethod(MethodCall call) async {
    String method = call.method;
    switch(method) {
      case 'poiSearchResult':
        {
          Map args = call.arguments;
          List<PoiSearch> list = [];
          (json.decode(args['poiSearchResult']) as List).forEach((value) {
            list.add(PoiSearch.fromJsonMap(value));
          });
          _widget.onPoiSearched(list);
          return new Future.value("");
        }
    }
    return new Future.value("");
  }

  Future<void> search(String keyWord) async {
    return await _channel.invokeMethod('search', <String, dynamic>{
      'keyWord': keyWord,
    });
  }

  Future<void> move(String lat, String lon) async {
    return await _channel.invokeMethod('move', <String, dynamic>{
      'lat': lat,
      'lon': lon
    });
  }

  Future<void> location() async {
    return await _channel.invokeMethod('location');
  }
}

/// 需要更多的初始化配置，可以在此处添加
class _CreationParams {
  _CreationParams({this.isPoiSearch});

  static _CreationParams fromWidget(AMap2DView widget) {
    return _CreationParams(
      isPoiSearch: widget.isPoiSearch,
    );
  }

  final bool isPoiSearch;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isPoiSearch': isPoiSearch,
    };
  }
}