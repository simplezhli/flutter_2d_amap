package com.weilu.flutter.flutter_2d_amap_example;

import com.weilu.flutter.flutter_2d_amap.Flutter2dAmapPlugin;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

public class MainActivity extends FlutterActivity {
  @Override
  public void configureFlutterEngine(FlutterEngine flutterEngine) {
    flutterEngine.getPlugins().add(new Flutter2dAmapPlugin());
  }
}
