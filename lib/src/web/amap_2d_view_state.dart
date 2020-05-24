
import 'dart:js_util';
import 'dart:ui' as ui;
import 'dart:html';
import 'package:flutter/scheduler.dart';
import 'package:flutter_2d_amap/src/web/amap_2d_controller.dart';
import 'package:flutter_2d_amap/src/web/amapjs.dart';
import 'package:flutter_2d_amap/src/web/loaderjs.dart';
import 'package:js/js.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';

class AMap2DViewState extends State<AMap2DView> {

  final htmlId = 'amap-${Uuid().v1()}';
  final plugins = ['AMap.Geolocation', 'AMap.PlaceSearch']; // 'AMap.Scale', 'AMap.ToolBar',

  AMap _aMap;
  DivElement _element;

  void _onPlatformViewCreated() {

    var promise = load(LoaderOptions(
      key: widget.webKey,
      version: '1.4.15',
      plugins: plugins,
    ));

    promiseToFuture(promise).then((value){
      MapOptions _mapOptions = MapOptions(
        zoom: 13,
      );
      _aMap = AMap(_element, _mapOptions);
      
      MarkerOptions _markerOptions = MarkerOptions(
        position: LngLat(116.397428, 39.90923),
        icon: AMapIcon(IconOptions(
            size: Size(26, 34),
            imageSize: Size(27, 34),
            image: 'https://a.amap.com/jsapi_demos/static/demo-center/icons/poi-marker-default.png'
          )
        ),
        offset: Pixel(-13, -34),
        anchor: 'bottom-center'
      );

      _aMap.add(Marker(_markerOptions));
      /// 加载插件
      _aMap.plugin(plugins, allowInterop(() {
//        _aMap.addControl(Scale());
//        _aMap.addControl(ToolBar());
        /// 定位
        Geolocation geolocation = Geolocation(GeolocationOptions(
          timeout: 15000,
          buttonPosition: 'RB',
          buttonOffset: Pixel(10, 20),
          zoomToAccuracy: true,
        ));
        geolocation.getCurrentPosition(allowInterop((status, result) {
          if (status == 'complete') {
            print(result.position);
            _aMap.setCenter(result.position);
          } else {
            /// 异常查询：https://lbs.amap.com/faq/js-api/map-js-api/position-related/43361
            /// Get geolocation time out：浏览器定位超时，包括原生的超时，可以适当增加超时属性的设定值以减少这一现象，
            /// 另外还有个别浏览器（如google Chrome浏览器等）本身的定位接口是黑洞，通过其请求定位完全没有回应，也会超时返回失败。
            print(result.message);
          }
        }));
      }));

      final AMap2DWebController controller = AMap2DWebController(_aMap);
      if (widget.onAMap2DViewCreated != null) {
        widget.onAMap2DViewCreated(controller);
      }
    }, onError: (e) {
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
    /// 先创建div并注册
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      _element = DivElement()
        ..id = htmlId
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.border = 'none'
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
      viewType: htmlId,
    );
  }
}