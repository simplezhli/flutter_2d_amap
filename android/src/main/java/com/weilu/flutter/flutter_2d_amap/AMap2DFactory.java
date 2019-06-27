package com.weilu.flutter.flutter_2d_amap;

import android.content.Context;

import java.util.Map;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

/**
 * @Description:
 * @Author: weilu
 * @Time: 2019/6/26 0026 10:16.
 */
public class AMap2DFactory extends PlatformViewFactory {

    private final PluginRegistry.Registrar registrar;
    
    public AMap2DFactory(PluginRegistry.Registrar registrar) {
        super(StandardMessageCodec.INSTANCE);
        this.registrar = registrar;
    }

    @Override
    public PlatformView create(Context context, int id, Object o) {
        Map<String, Object> params = (Map<String, Object>) o;
        return new AMap2DView(context, registrar, id, params);
    }
}
