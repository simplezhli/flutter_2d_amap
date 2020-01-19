package com.weilu.flutter.flutter_2d_amap;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** Flutter2dAmapPlugin */
public class Flutter2dAmapPlugin implements FlutterPlugin, ActivityAware{

  private AMap2DDelegate delegate;
  private FlutterPluginBinding pluginBinding;
  private ActivityPluginBinding activityBinding;
  
  public Flutter2dAmapPlugin() {}
  
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    if (registrar.activity() == null) {
      return;
    }
    // 添加权限回调监听
    final AMap2DDelegate delegate = new AMap2DDelegate(registrar.activity());
    registrar.addRequestPermissionsResultListener(delegate);
    registrar.platformViewRegistry().registerViewFactory("plugins.weilu/flutter_2d_amap", new AMap2DFactory(registrar.messenger(), delegate));
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    pluginBinding = binding;
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    pluginBinding = null;
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activityBinding = binding;
    
    BinaryMessenger messenger = pluginBinding.getBinaryMessenger();
    AMap2DFactory mFactory = new AMap2DFactory(messenger, null);
    pluginBinding.getPlatformViewRegistry().registerViewFactory("plugins.weilu/flutter_2d_amap", mFactory);
    
    delegate = new AMap2DDelegate(binding.getActivity());
    binding.addRequestPermissionsResultListener(delegate);
    mFactory.setDelegate(delegate);
  }

  @Override
  public void onDetachedFromActivity() {
    tearDown();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  private void tearDown() {
    activityBinding.removeRequestPermissionsResultListener(delegate);
    activityBinding = null;
    delegate = null;
  }
}
