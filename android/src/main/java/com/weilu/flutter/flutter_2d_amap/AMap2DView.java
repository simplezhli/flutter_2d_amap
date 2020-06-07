package com.weilu.flutter.flutter_2d_amap;

import android.content.Context;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.amap.api.location.AMapLocation;
import com.amap.api.location.AMapLocationClient;
import com.amap.api.location.AMapLocationClientOption;
import com.amap.api.location.AMapLocationListener;
import com.amap.api.maps2d.AMap;
import com.amap.api.maps2d.CameraUpdateFactory;
import com.amap.api.maps2d.LocationSource;
import com.amap.api.maps2d.MapView;
import com.amap.api.maps2d.model.BitmapDescriptor;
import com.amap.api.maps2d.model.BitmapDescriptorFactory;
import com.amap.api.maps2d.model.LatLng;
import com.amap.api.maps2d.model.Marker;
import com.amap.api.maps2d.model.MarkerOptions;
import com.amap.api.maps2d.model.MyLocationStyle;
import com.amap.api.services.core.AMapException;
import com.amap.api.services.core.LatLonPoint;
import com.amap.api.services.core.PoiItem;
import com.amap.api.services.poisearch.PoiResult;
import com.amap.api.services.poisearch.PoiSearch;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

/**
 * @Description:
 * @Author: weilu
 * @Time: 2019/6/26 0026 10:18.
 */
public class AMap2DView implements PlatformView, MethodChannel.MethodCallHandler, LocationSource, AMapLocationListener,
        AMap.OnMapClickListener, PoiSearch.OnPoiSearchListener {
    
    private static  final String SEARCH_CONTENT = "010000|010100|020000|030000|040000|050000|050100|060000|060100|060200|060300|060400|070000|080000|080100|080300|080500|080600|090000|090100|090200|090300|100000|100100|110000|110100|120000|120200|120300|130000|140000|141200|150000|150100|150200|160000|160100|170000|170100|170200|180000|190000|200000";
  
    private MapView mAMap2DView;
    private AMap aMap;
    private PoiSearch.Query query;
    private OnLocationChangedListener mListener;
    private AMapLocationClient mLocationClient;

    private final MethodChannel methodChannel;
    private final Handler platformThreadHandler;
    private Runnable postMessageRunnable;
    private final Context context;
    private String keyWord = "";
    private boolean isPoiSearch;
    private static final String IS_POI_SEARCH = "isPoiSearch";
    private String city = "";

    AMap2DView(final Context context, BinaryMessenger messenger, int id, Map<String, Object> params, AMap2DDelegate delegate) {
        this.context = context;
        platformThreadHandler = new Handler(context.getMainLooper());
        createMap(context);
        setAMap2DDelegate(delegate);
        mAMap2DView.onResume();
        methodChannel = new MethodChannel(messenger, "plugins.weilu/flutter_2d_amap_" + id);
        methodChannel.setMethodCallHandler(this);

        if (params.containsKey(IS_POI_SEARCH)) {
            isPoiSearch = (boolean) params.get(IS_POI_SEARCH);
        }
    }
    
    void setAMap2DDelegate(AMap2DDelegate delegate) {
        if (delegate != null){
            delegate.requestPermissions(new AMap2DDelegate.RequestPermission() {
                @Override
                public void onRequestPermissionSuccess() {
                    setUpMap();
                }

                @Override
                public void onRequestPermissionFailure() {
                    Toast.makeText(context,"定位失败，请检查定位权限是否开启！", Toast.LENGTH_SHORT).show();
                }
            });
        }
    }
    
    private void createMap(Context context) {
        mAMap2DView = new MapView(context);
        mAMap2DView.onCreate(new Bundle());
        aMap = mAMap2DView.getMap();
    }
    
    private void setUpMap() {
        CameraUpdateFactory.zoomTo(32);
        aMap.setOnMapClickListener(this);
        // 设置定位监听
        aMap.setLocationSource(this);
        // 设置默认定位按钮是否显示
        aMap.getUiSettings().setMyLocationButtonEnabled(true);
        MyLocationStyle myLocationStyle = new MyLocationStyle();
        myLocationStyle.strokeWidth(1f);
        myLocationStyle.strokeColor(Color.parseColor("#8052A3FF"));
        myLocationStyle.radiusFillColor(Color.parseColor("#3052A3FF"));
        myLocationStyle.showMyLocation(true);
        myLocationStyle.myLocationIcon(BitmapDescriptorFactory.fromResource(R.drawable.yd));
        myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_LOCATE);
        aMap.setMyLocationStyle(myLocationStyle);
        // 设置为true表示显示定位层并可触发定位，false表示隐藏定位层并不可触发定位，默认是false
        aMap.setMyLocationEnabled(true);
    }
    
    @Override
    public void onMethodCall(MethodCall methodCall, @NonNull MethodChannel.Result result) {
        String method = methodCall.method;
        Map<String, Object> request = (Map<String, Object>) methodCall.arguments;
        switch(method) {
            case "search":
                keyWord = (String) request.get("keyWord");
                city = (String) request.get("city");
                search();
                break;
            case "move":
                move(toDouble((String) request.get("lat")), toDouble((String) request.get("lon")));
                break;
            case "location":
                if (mLocationClient != null) {
                    mLocationClient.startLocation();
                }
                break;
            default:
                break;    
        }
    }

    private double toDouble(String obj) {
        try {
            return Double.parseDouble(obj);
        } catch (Exception e) {
            e.fillInStackTrace();
        }
        return 0D;
    }
    
    @Override
    public View getView() {
        return mAMap2DView;
    }

    @Override
    public void dispose() {
        mAMap2DView.onDestroy();
        platformThreadHandler.removeCallbacks(postMessageRunnable);
        methodChannel.setMethodCallHandler(null);
    }

    @Override
    public void onLocationChanged(AMapLocation aMapLocation) {
        if (mListener != null && aMapLocation != null) {
            if (aMapLocation.getErrorCode() == 0) {
                // 显示系统小蓝点
                mListener.onLocationChanged(aMapLocation);
                aMap.moveCamera(CameraUpdateFactory.zoomTo(16));
                search(aMapLocation.getLatitude(), aMapLocation.getLongitude());
                if (mLocationClient != null) {
                    mLocationClient.stopLocation();
                }
            } else {
                Toast.makeText(context,"定位失败，请检查GPS是否开启！", Toast.LENGTH_SHORT).show();
                if (mLocationClient != null) {
                    mLocationClient.stopLocation();
                }
            }
        }
    }

    private void search() {
        if (!isPoiSearch) {
            return;
        }
        query = new PoiSearch.Query(keyWord, SEARCH_CONTENT, city);
        // 设置每页最多返回多少条poiitem
        query.setPageSize(50);
        query.setPageNum(0);
        PoiSearch poiSearch = new PoiSearch(context, query);
        poiSearch.setOnPoiSearchListener(this);
        poiSearch.searchPOIAsyn();
    }

    private void move(double lat, double lon) {
        LatLng latLng = new LatLng(lat, lon);
        drawMarkers(latLng, BitmapDescriptorFactory.defaultMarker());
    }

    private void search(double latitude, double longitude) {
        if (!isPoiSearch) {
            return;
        }
        query = new PoiSearch.Query("", SEARCH_CONTENT, "");
        // 设置每页最多返回多少条poiitem
        query.setPageSize(50);
        query.setPageNum(0);

        PoiSearch poiSearch = new PoiSearch(context, query);
        poiSearch.setOnPoiSearchListener(this);
        LatLonPoint latLonPoint = new LatLonPoint(latitude, longitude);
        poiSearch.setBound(new PoiSearch.SearchBound(latLonPoint, 2000, true));
        poiSearch.searchPOIAsyn();
    }

    @Override
    public void onMapClick(LatLng latLng) {
        drawMarkers(latLng, BitmapDescriptorFactory.defaultMarker());
        search(latLng.latitude, latLng.longitude);
    }

    private Marker mMarker;
    
    private void drawMarkers(LatLng latLng, BitmapDescriptor bitmapDescriptor) {
        aMap.animateCamera(CameraUpdateFactory.changeLatLng(new LatLng(latLng.latitude, latLng.longitude)));
        if (mMarker == null) {
            mMarker = aMap.addMarker(new MarkerOptions().position(latLng).icon(bitmapDescriptor).draggable(true));
        } else {
            mMarker.setPosition(latLng);
        }
    }

    @Override
    public void activate(OnLocationChangedListener onLocationChangedListener) {
        mListener = onLocationChangedListener;
        if (mLocationClient == null) {
            mLocationClient = new AMapLocationClient(context);
            AMapLocationClientOption locationOption = new AMapLocationClientOption();
            mLocationClient.setLocationListener(this);
            //设置为高精度定位模式
            locationOption.setLocationMode(AMapLocationClientOption.AMapLocationMode.Hight_Accuracy);
            //设置定位参数
            mLocationClient.setLocationOption(locationOption);
            mLocationClient.startLocation();
        }
    }

    @Override
    public void deactivate() {
        mListener = null;
        if (mLocationClient != null) {
            mLocationClient.stopLocation();
            mLocationClient.onDestroy();
        }
        mLocationClient = null;
    }

    private final StringBuilder builder = new StringBuilder();

    @Override
    public void onPoiSearched(PoiResult result, int code) {

        builder.delete(0, builder.length());
        // 拼接json（避免引用gson之类的库，小插件不必要。。。）
        builder.append("[");

        if (code == AMapException.CODE_AMAP_SUCCESS) {
            // 搜索poi的结果
            if (result != null && result.getQuery() != null) {
                // 是否是同一条
                if (result.getQuery().equals(query)) {
                    final List<PoiItem> list = result.getPois();

                    for (int i = 0; i < list.size(); i++) {
                        PoiItem item = list.get(i);
                        builder.append("{");
                        builder.append("\"cityCode\": \"");builder.append(item.getCityCode());builder.append("\",");
                        builder.append("\"cityName\": \"");builder.append(item.getCityName());builder.append("\",");
                        builder.append("\"provinceName\": \"");builder.append(item.getProvinceName());builder.append("\",");
                        builder.append("\"title\": \"");builder.append(item.getTitle());builder.append("\",");
                        builder.append("\"adName\": \"");builder.append(item.getAdName());builder.append("\",");
                        builder.append("\"provinceCode\": \"");builder.append(item.getProvinceCode());builder.append("\",");
                        builder.append("\"latitude\": \"");builder.append(item.getLatLonPoint().getLatitude());builder.append("\",");
                        builder.append("\"longitude\": \"");builder.append(item.getLatLonPoint().getLongitude());builder.append("\"");
                        builder.append("},");
                        if (i == list.size() - 1) {
                            builder.deleteCharAt(builder.length() - 1);
                        }
                    }

                    if (list.size() > 0) {
                        aMap.moveCamera(CameraUpdateFactory.zoomTo(16));
                        move(list.get(0).getLatLonPoint().getLatitude(), list.get(0).getLatLonPoint().getLongitude());
                    }
                }
            }
        }
        builder.append("]");
        postMessageRunnable = new Runnable() {
            @Override
            public void run() {
                Map<String, String> map = new HashMap<>(2);
                map.put("poiSearchResult", builder.toString());
                methodChannel.invokeMethod("poiSearchResult", map);
            }
        };
        if (platformThreadHandler.getLooper() == Looper.myLooper()) {
            postMessageRunnable.run();
        } else {
            platformThreadHandler.post(postMessageRunnable);
        }
    }

    @Override
    public void onPoiItemSearched(PoiItem poiItem, int i) {

    }
}
