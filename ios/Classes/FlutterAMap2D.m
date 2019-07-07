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
#import <AMapSearchKit/AMapSearchKit.h>

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


@interface FlutterAMap2DController()<AMapLocationManagerDelegate, AMapSearchDelegate>

    @property (strong, nonatomic) CLLocationManager *mannger;
    @property (strong, nonatomic) AMapLocationManager *locationManager;
    @property (strong, nonatomic) AMapSearchAPI *search;
@end

@implementation FlutterAMap2DController {
    MAMapView* _mapView;
    int64_t _viewId;
    FlutterMethodChannel* _channel;
    NSString* _types;
    bool _isPoiSearch;
}
    
- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if ([super init]) {
        _types = @"汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
        _viewId = viewId;
        NSString* channelName = [NSString stringWithFormat:@"plugins.weilu/flutter_2d_amap_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            [weakSelf onMethodCall:call result:result];
        }];
        _isPoiSearch = [args[@"isPoiSearch"] boolValue] == YES;
        /// 初始化地图
        _mapView = [[MAMapView alloc] initWithFrame:frame];
        if ([self hasPermission]){
            _mapView.showsUserLocation = YES;
            _mapView.userTrackingMode = MAUserTrackingModeFollow;
            /// 初始化定位
            self.locationManager = [[AMapLocationManager alloc] init];
            self.locationManager.delegate = self;
            /// 开始定位
            [self.locationManager startUpdatingLocation];
            /// 初始化搜索
            self.search = [[AMapSearchAPI alloc] init];
            self.search.delegate = self;
            
        }else{
            self.mannger =  [[CLLocationManager alloc] init];
            [self.mannger requestWhenInUseAuthorization];
        }
    }
    return self;
}

//接收位置更新,实现AMapLocationManagerDelegate代理的amapLocationManager:didUpdateLocation方法，处理位置更新

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    CLLocationCoordinate2D center;
    center.latitude = location.coordinate.latitude;
    center.longitude = location.coordinate.longitude;
    [_mapView setZoomLevel:18 animated: YES];
    [_mapView setCenterCoordinate:center animated:YES];
    [self.locationManager stopUpdatingLocation];
    
    if (_isPoiSearch){
        
        AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
        
        request.types               = _types;
        request.requireExtension    = YES;
        request.offset              = 50;
        request.location            = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude               longitude:location.coordinate.longitude];
        [self.search AMapPOIKeywordsSearch:request];
    }
  
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if (response.pois.count == 0){
        return;
    }
    
    //1. 初始化可变字符串，存放最终生成json字串
    NSMutableString *jsonString = [[NSMutableString alloc] initWithString:@"["];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        if (idx == 0){
            CLLocationCoordinate2D center;
            center.latitude = obj.location.latitude;
            center.longitude = obj.location.longitude;
            [self->_mapView setZoomLevel:18 animated: YES];
            [self->_mapView setCenterCoordinate:center animated:YES];
        }
        //2. 遍历数组，取出键值对并按json格式存放
        NSString *string  = [NSString stringWithFormat:@"{\"cityCode\":\"%@\",\"cityName\":\"%@\",\"provinceName\":\"%@\",\"title\":\"%@\",\"adName\":\"%@\",\"provinceCode\":\"%@\",\"latitude\":\"%f\",\"longitude\":\"%f\"},", obj.citycode, obj.city, obj.province, obj.name, obj.district, obj.pcode, obj.location.latitude, obj.location.longitude];
        [jsonString appendString:string];
        
    }];
    
    // 3. 获取末尾逗号所在位置
    NSUInteger location = [jsonString length] - 1;
    
    NSRange range = NSMakeRange(location, 1);
    
    // 4. 将末尾逗号换成结束的]
    [jsonString replaceCharactersInRange:range withString:@"]"];
    
    NSDictionary* arguments = @{
                                @"poiSearchResult" : jsonString
                                };
    [_channel invokeMethod:@"poiSearchResult" arguments:arguments];
    
}

//字典转Json
- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
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
    if ([[call method] isEqualToString:@"search"]) {
        if (_isPoiSearch){
            AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
            request.types               = _types;
            request.requireExtension    = YES;
            request.offset              = 50;
            request.keywords            = [call arguments][@"keyWord"];
            [self.search AMapPOIKeywordsSearch:request];
        }
    } else if ([[call method] isEqualToString:@"move"]) {
        NSString* lat = [call arguments][@"lat"];
        NSString* lon = [call arguments][@"lon"];
        CLLocationCoordinate2D center;
        center.latitude = [lat doubleValue];
        center.longitude = [lon doubleValue];
        [self->_mapView setZoomLevel:18 animated: YES];
        [self->_mapView setCenterCoordinate:center animated:YES];
    }
}
@end
