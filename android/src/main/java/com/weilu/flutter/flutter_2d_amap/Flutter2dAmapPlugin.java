package com.weilu.flutter.flutter_2d_amap;

import io.flutter.plugin.common.PluginRegistry.Registrar;

/** Flutter2dAmapPlugin */
public class Flutter2dAmapPlugin{
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    registrar.platformViewRegistry().registerViewFactory("flutter_2d_amap", new AMap2DFactory(registrar));
  }
}
