package com.weilu.flutter.flutter_2d_amap;

import io.flutter.plugin.common.PluginRegistry.Registrar;

/** Flutter2dAmapPlugin */
public class Flutter2dAmapPlugin{
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    // 添加权限回调监听
    final AMap2DDelegate delegate = new AMap2DDelegate(registrar.activity());
    registrar.addRequestPermissionsResultListener(delegate);
    registrar.platformViewRegistry().registerViewFactory("plugins.weilu/flutter_2d_amap", new AMap2DFactory(registrar, delegate));
  }
}
