@JS('AMap')
library amap;

import 'package:js/js.dart';

/// 高德地图js，文档：https://lbs.amap.com/api/javascript-api/guide/abc/prepare
@JS('Map')
class AMap {
  external AMap(dynamic /*String|DivElement*/ div, MapOptions opts);
  /// 设置中心点 
  external setCenter(LngLat center);
  /// 设置地图显示的缩放级别，参数 zoom 可设范围：[2, 20]
  external setZoom(num zoom);
  /// 添加覆盖物/图层。参数为单个覆盖物/图层，或覆盖物/图层的数组。
  external add(dynamic /*Array<any> | Marker*/ features);
  /// 删除覆盖物/图层。参数为单个覆盖物/图层，或覆盖物/图层的数组。
  external remove(dynamic /*Array | Marker*/ features);
  /// 删除所有覆盖物
  external clearMap();
  /// 加载插件
  external plugin(dynamic/*String|List*/ name, void Function() callback);
  /// 添加控件，参数可以是插件列表中的任何插件对象，如：ToolBar、OverView、Scale等 
  external addControl(Control control);
  /// 销毁地图，并清空地图容器
  external destroy();

  external on(String eventName, void Function(MapsEvent event) callback);
}

@JS()
class Geolocation extends Control {
  external Geolocation(GeolocationOptions opts);
  external getCurrentPosition(Function(String status, GeolocationResult result) callback);
}

@JS()
class PlaceSearch {
  external PlaceSearch(PlaceSearchOptions opts);
  external search(String keyword, Function(String status, SearchResult result) callback);
  /// 根据中心点经纬度、半径以及关键字进行周边查询 radius取值范围：0-50000
  external searchNearBy(String keyword, LngLat center, num radius, Function(String status, SearchResult result) callback);
  external setType(String type);
  external setPageIndex(int pageIndex);
  external setPageSize(int pageSize);
  external setCity(String city);
}

@JS()
class LngLat {
  external LngLat(num lng, num lat);
  external num getLng();
  external num getLat();
}

@JS()
class Pixel {
  external Pixel(num x, num y);
}

@JS()
class Marker {
  external Marker(MarkerOptions opts);
}

@JS()
class Control {
  external Control();
}

@JS()
class Scale extends Control {
  external Scale();
}

@JS()
class ToolBar extends Control {
  external ToolBar();
}

@JS('Icon')
class AMapIcon {
  external AMapIcon(IconOptions options);
}

@JS()
class Size {
  external Size(num width, num height);
}

@JS()
@anonymous
class MapsEvent {
  external LngLat get lnglat;
}

@JS()
@anonymous
class MapOptions {
 
  external factory MapOptions({
    /// 初始中心经纬度
    LngLat center,
    bool resizeEnable,
    /// 地图显示的缩放级别
    num zoom,
    /// 地图视图模式, 默认为‘2D’
    String /*‘2D’|‘3D’*/ viewMode,
  });

  external LngLat get center;
  external num get zoom;
  external String get viewMode;
}

@JS()
@anonymous
class MarkerOptions {
  
  external factory MarkerOptions({
    /// 要显示该marker的地图对象
    AMap map,
    /// 点标记在地图上显示的位置
    LngLat position,
    AMapIcon icon,
    String title,
    Pixel offset,
    String anchor,
  });

  external LngLat get position;
  external set position(LngLat v);
}

@JS()
@anonymous
class GeolocationOptions {
  external factory GeolocationOptions({
    /// 是否使用高精度定位，默认：true
    bool enableHighAccuracy,
    /// 设置定位超时时间，默认：无穷大
    int timeout,
    /// 定位按钮的停靠位置的偏移量，默认：Pixel(10, 20)
    Pixel buttonOffset,
    ///  定位成功后调整地图视野范围使定位位置及精度范围视野内可见，默认：false
    bool zoomToAccuracy,
    ///  定位按钮的排放位置,  RB表示右下 
    String buttonPosition,
  });
}

@JS()
@anonymous
class PlaceSearchOptions {
  external factory PlaceSearchOptions({
    ///此项默认值：base，返回基本地址信息
    /// 取值：all，返回基本+详细信息
    String extensions,
    String type,
    int pageSize,
    int pageIndex,
  });
}

@JS()
@anonymous
class IconOptions {
  external factory IconOptions({
    Size size,
    String image,
    Size imageSize,
  });
}

@JS()
@anonymous
class GeolocationResult {
  external LngLat get position;
  external String get message;
}

@JS()
@anonymous
class SearchResult {
  external PoiList get poiList;
  /// 成功状态说明
  external String get info;
}

@JS()
@anonymous
class PoiList {
  external List<dynamic> get pois;
  /// 查询结果总数
  external int get count;
}

@JS()
@anonymous
class Poi {
  external String get citycode;
  external String get cityname;
  external String get pname;
  external String get pcode;
  external LngLat get location;
  external String get adname;
  external String get name;
}
