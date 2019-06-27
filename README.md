# flutter_2d_amap

本插件主要服务于 [flutter_deer](https://github.com/simplezhli/flutter_deer)

高德2D地图插件 （暂时只实现了Android部分，未处理权限申请，逐步完善中）

## 效果展示

<img src="preview/Screenshot_1.jpg" width="450px"/>

## 实现功能包括

* 定位并自动移动地图至当前位置
* 默认获取POI数据并返回
* 支持传入经纬度来移动地图
* 支持搜索POI

## 使用方式

```dart

flutter_2d_amap:
    git:
      url: git://github.com/simplezhli/flutter_2d_amap.git

import 'package:flutter_2d_amap/flutter_2d_amap.dart';

Android AndroidManifest.xml 中添加：

<meta-data
     android:name="com.amap.api.v2.apikey"
     android:value="配置你的key"/>
```

## License

	Copyright 2019 simplezhli

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
