@JS('AMapLoader')
library loader;

import 'package:js/js.dart';

/// 高德地图 Loader js
external load(LoaderOptions options);

@JS()
@anonymous
class LoaderOptions {

  external factory LoaderOptions({
    ///您申请的key值
    String? key,
    /// JSAPI 版本号
    String version,
    //同步加载的插件列表 (https://lbs.amap.com/api/jsapi-v2/guide/abc/plugins)
    List<String> plugins,
  });
}