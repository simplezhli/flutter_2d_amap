#import "Flutter2dAmapPlugin.h"
#import "AMapFoundationKit/AMapFoundationKit.h"
#import "FlutterAMap2D.h"
#import "AMapSearchAPI.h"
#import "AMapLocationManager.h"

@implementation Flutter2dAmapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"plugins.weilu/flutter_2d_amap_"
            binaryMessenger:[registrar messenger]];
  Flutter2dAmapPlugin* instance = [[Flutter2dAmapPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];

  FlutterAMap2DFactory* aMap2DFactory =
  [[FlutterAMap2DFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:aMap2DFactory withId:@"plugins.weilu/flutter_2d_amap"];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"setKey" isEqualToString:call.method]) {
    NSString *key = call.arguments;
    [AMapServices sharedServices].enableHTTPS = YES;
    // 配置高德地图的key
    [AMapServices sharedServices].apiKey = key;
    result(@YES);
  } else if ([@"updatePrivacy" isEqualToString:call.method]) {
    if ([@"true" isEqualToString:call.arguments]) {
      [AMapSearchAPI updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
      [AMapSearchAPI updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
      [AMapLocationManager updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
      [AMapLocationManager updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
    } else {
      [AMapSearchAPI updatePrivacyShow:AMapPrivacyShowStatusNotShow privacyInfo:AMapPrivacyInfoStatusNotContain];
      [AMapSearchAPI updatePrivacyAgree:AMapPrivacyAgreeStatusNotAgree];
      [AMapLocationManager updatePrivacyShow:AMapPrivacyShowStatusNotShow privacyInfo:AMapPrivacyInfoStatusNotContain];
      [AMapLocationManager updatePrivacyAgree:AMapPrivacyAgreeStatusNotAgree];
    }
    result(@YES);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
