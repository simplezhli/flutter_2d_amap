## 0.1.0

* 支持Web。（基本功能使用没问题，部分地图显示有问题。）

## 0.0.4

* POI搜索支持指定城市，默认全国。
* 地图点击替换为POI周边查询接口。

## 0.0.3

* 点击地图选点时，去除地图缩放。
* 更新Android依赖至最新：

```groovy
    api 'com.amap.api:map2d:6.0.0'
    api 'com.amap.api:search:7.1.0'
    api 'com.amap.api:location:4.8.0'
```

## 0.0.2

* 支持Flutter 1.12版本新的android插件api
* Android权限申请优化

## 0.0.1

* 处理地图所需权限申请
* 定位并自动移动地图至当前位置
* 默认获取POI数据并返回
* 支持传入经纬度来移动地图
* 支持搜索POI
