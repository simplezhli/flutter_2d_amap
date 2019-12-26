package com.weilu.flutter.flutter_2d_amap;

import android.content.Context;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

/**
 * @Description:
 * @Author: weilu
 * @Time: 2019/6/26 0026 10:16.
 */
public class AMap2DFactory extends PlatformViewFactory {

    private final BinaryMessenger messenger;
    private AMap2DDelegate delegate;
    private AMap2DView mAMap2DView;

    AMap2DFactory(BinaryMessenger messenger, AMap2DDelegate delegate) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
        this.delegate = delegate;
    }

    void setDelegate(AMap2DDelegate delegate) {
        this.delegate = delegate;
        if (mAMap2DView != null) {
            mAMap2DView.setAMap2DDelegate(delegate);
        }
    }

    @Override
    public PlatformView create(Context context, int id, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;
        mAMap2DView = new AMap2DView(context, messenger, id, params, delegate);
        return mAMap2DView;
    }
}
