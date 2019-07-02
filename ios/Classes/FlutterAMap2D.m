//
//  FlutterAMap2D.m
//  flutter_2d_amap
//
//  Created by weilu on 2019/7/1.
//

#import "FlutterAMap2D.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapLocationKit/AMapLocationKit.h>

@implementation FlutterAMap2DFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}
    
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}
    
- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}
    
- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    FlutterAMap2DController* aMap2DController = [[FlutterAMap2DController alloc] initWithFrame:frame
                                                                                viewIdentifier:viewId
                                                                                     arguments:args
                                                                               binaryMessenger:_messenger];
    return aMap2DController;
}
    
    @end


@interface FlutterAMap2DController()
    
    @property (strong, nonatomic) CLLocationManager *mannger;
    
    @end

@implementation FlutterAMap2DController {
    MAMapView* _mapView;
    int64_t _viewId;
    FlutterMethodChannel* _channel;
    AMapLocationManager* _locationManager;
}
    
- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if ([super init]) {
        _viewId = viewId;
        [AMapServices sharedServices].enableHTTPS = YES;
        [AMapServices sharedServices].apiKey = @"1a8f6a489483534a9f2ca96e4eeeb9b3";
        NSString* channelName = [NSString stringWithFormat:@"plugins.weilu/flutter_2d_amap_%lld",viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        /// 初始化地图
        _mapView = [[MAMapView alloc] initWithFrame:frame];
        if ([self hasPermission]){
            _mapView.showsUserLocation = YES;
            _mapView.userTrackingMode = MAUserTrackingModeFollow;
            [_mapView setZoomLevel:17.5 animated: YES];
            _locationManager = [[AMapLocationManager alloc] init];
            ///_locationManager.delegate = self;
            
        }else{
            self.mannger =  [[CLLocationManager alloc] init];
            [self.mannger requestWhenInUseAuthorization];
        }
    }
    return self;
}
    
- (UIView*)view {
    return _mapView;
}
    
    //检查是否授予定位权限
- (bool)hasPermission{
    CLAuthorizationStatus locationStatus =  [CLLocationManager authorizationStatus];
    return (bool)(locationStatus == kCLAuthorizationStatusAuthorizedWhenInUse || locationStatus == kCLAuthorizationStatusAuthorizedAlways);
}
    
- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
}
    @end
