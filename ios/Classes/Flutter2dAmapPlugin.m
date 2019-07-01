#import "Flutter2dAmapPlugin.h"
#import "AMapFoundationKit/AMapFoundationKit.h"
#import "FlutterAMap2D.h"

@implementation Flutter2dAmapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"plugins.weilu/flutter_2d_amap"
            binaryMessenger:[registrar messenger]];
  Flutter2dAmapPlugin* instance = [[Flutter2dAmapPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];

  FlutterAMap2DFactory* aMap2DFactory =
  [[FlutterAMap2DFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:aMap2DFactory withId:@"plugins.weilu/flutter_2d_amap"];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"setKey" isEqualToString:call.method]) {
    // NSString *key = call.arguments[@"key"];
    // 配置高德地图的key
    [AMapServices sharedServices].apiKey = @"1a8f6a489483534a9f2ca96e4eeeb9b3";
    result(@"key设置成功");
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
