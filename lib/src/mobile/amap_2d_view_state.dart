

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';
import 'package:flutter_2d_amap/src/mobile/amap_2d_controller.dart';


class AMap2DViewState extends State<AMap2DView> {

  final Completer<AMap2DMobileController> _controller = Completer<AMap2DMobileController>();

  void _onPlatformViewCreated(int id) {
    final AMap2DMobileController controller = AMap2DMobileController(id, widget);
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