
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_util';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/scheduler.dart';
import 'package:flutter_2d_amap/src/web/amap_2d_controller.dart';
import 'package:flutter_2d_amap/src/web/amapjs.dart';
import 'package:flutter_2d_amap/src/web/loaderjs.dart';
import 'package:js/js.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';

class AMap2DViewState extends State<AMap2DView> {

  /// 加载的插件
  final List<String> plugins = <String>['AMap.Geolocation', 'AMap.PlaceSearch', 'AMap.Scale', 'AMap.ToolBar'];
  
  AMap _aMap;
  String _divId;
  DivElement _element;

  void _onPlatformViewCreated() {

    var promise = load(LoaderOptions(
      key: widget.webKey,
      version: '1.4.15',
      plugins: plugins,
    ));

    promiseToFuture(promise).then((value){
      MapOptions _mapOptions = MapOptions(
        zoom: 11,
        resizeEnable: true,
      );
      /// 无法使用id https://github.com/flutter/flutter/issues/40080
      _aMap = AMap(_element, _mapOptions);
      /// 加载插件
      _aMap.plugin(plugins, allowInterop(() {
        _aMap.addControl(Scale());
        _aMap.addControl(ToolBar());

        final AMap2DWebController controller = AMap2DWebController(_aMap, widget);
        if (widget.onAMap2DViewCreated != null) {
          widget.onAMap2DViewCreated(controller);
        }
      }));

    }, onError: (dynamic e) {
      print('初始化错误：$e');
    });
  }

  @override
  void dispose() {
    _aMap.destroy();
    _aMap = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _divId = DateTime.now().toIso8601String();
    /// 先创建div并注册
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(_divId, (int viewId) {
      _element = DivElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.margin = '0';

      return _element;
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      /// 创建地图
      _onPlatformViewCreated();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      viewType: _divId,
    );
  }
}