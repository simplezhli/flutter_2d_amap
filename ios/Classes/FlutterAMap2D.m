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
#import <CoreGraphics/CoreGraphics.h>

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


@interface FlutterAMap2DController()<AMapLocationManagerDelegate, AMapSearchDelegate, CLLocationManagerDelegate, MAMapViewDelegate>

    @property (strong, nonatomic) CLLocationManager *mannger;
    @property (strong, nonatomic) AMapLocationManager *locationManager;
    @property (strong, nonatomic) AMapSearchAPI *search;
@end

@implementation FlutterAMap2DController {
    MAMapView* _mapView;
    int64_t _viewId;
    FlutterMethodChannel* _channel;
    
    MAPointAnnotation* _pointAnnotation;
    bool _isPoiSearch;
}

NSString* _types = @"010000|010100|020000|030000|040000|050000|050100|060000|060100|060200|060300|060400|070000|080000|080100|080300|080500|080600|090000|090100|090200|090300|100000|100100|110000|110100|120000|120200|120300|130000|140000|141200|150000|150100|150200|160000|160100|170000|170100|170200|180000|190000|200000";
    
- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if ([super init]) {

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
        _mapView.delegate = self;
        // 请求定位权限
        self.mannger =  [[CLLocationManager alloc] init];
        self.mannger.delegate = self;
        [self.mannger requestWhenInUseAuthorization];
    }
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:{
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
            break;
        }
        default:
            NSLog(@"授权失败");
            break;
    }
}

#pragma mark 点击地图方法
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self->_mapView setCenterCoordinate:coordinate animated:YES];
    [self drawMarkers:coordinate.latitude lon:coordinate.longitude];
    [self searchPOI:coordinate.latitude lon:coordinate.longitude];
}

//接收位置更新,实现AMapLocationManagerDelegate代理的amapLocationManager:didUpdateLocation方法，处理位置更新
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    CLLocationCoordinate2D center;
    center.latitude = location.coordinate.latitude;
    center.longitude = location.coordinate.longitude;
    [_mapView setZoomLevel:17 animated: YES];
    [_mapView setCenterCoordinate:center animated:YES];
    [self.locationManager stopUpdatingLocation];
    [self searchPOI:location.coordinate.latitude lon:location.coordinate.longitude];
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if (response.pois.count == 0) {
        NSDictionary* arguments = @{@"poiSearchResult" : @"[]"};
        [_channel invokeMethod:@"poiSearchResult" arguments:arguments];
        return;
    }
    
    //1. 初始化可变字符串，存放最终生成json字串
    NSMutableString *jsonString = [[NSMutableString alloc] initWithString:@"["];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        if (idx == 0) {
            CLLocationCoordinate2D center;
            center.latitude = obj.location.latitude;
            center.longitude = obj.location.longitude;
            [self->_mapView setZoomLevel:17 animated: YES];
            [self->_mapView setCenterCoordinate:center animated:YES];
            [self drawMarkers:obj.location.latitude lon:obj.location.longitude];
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

- (void)drawMarkers:(CGFloat)lat lon:(CGFloat)lon {
    if (self->_pointAnnotation == NULL) {
        self->_pointAnnotation = [[MAPointAnnotation alloc] init];
        self->_pointAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
        [self->_mapView addAnnotation:self->_pointAnnotation];
    } else {
        self->_pointAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
    }
}

- (void)searchPOI:(CGFloat)lat lon:(CGFloat)lon{
    
    if (_isPoiSearch) {
        AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
        request.types               = _types;
        request.requireExtension    = YES;
        request.offset              = 50;
        request.location            = [AMapGeoPoint locationWithLatitude:lat longitude:lon];
        [self.search AMapPOIAroundSearch:request];
    }
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([[call method] isEqualToString:@"search"]) {
        if (_isPoiSearch) {
            AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
            request.types               = _types;
            request.requireExtension    = YES;
            request.offset              = 50;
            request.keywords            = [call arguments][@"keyWord"];
            request.city                = [call arguments][@"city"];
            [self.search AMapPOIKeywordsSearch:request];
        }
    } else if ([[call method] isEqualToString:@"move"]) {
        NSString* lat = [call arguments][@"lat"];
        NSString* lon = [call arguments][@"lon"];
        CLLocationCoordinate2D center;
        center.latitude = [lat doubleValue];
        center.longitude = [lon doubleValue];
        [self->_mapView setCenterCoordinate:center animated:YES];
        [self drawMarkers:[lat doubleValue] lon:[lon doubleValue]];
    } else if ([[call method] isEqualToString:@"location"]) {
        [self.locationManager startUpdatingLocation]; 
    }
}
@end
