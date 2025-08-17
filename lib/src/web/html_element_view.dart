import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// https://github.com/deakjahn/flutter_dropzone
// https://github.com/flutter/flutter/issues/56181

class HtmlElementViewEx extends HtmlElementView {

  const HtmlElementViewEx({super.key, required super.viewType, required this.onPlatformViewCreatedCallback});

  final PlatformViewCreatedCallback onPlatformViewCreatedCallback;

  @override
  Widget build(BuildContext context) => PlatformViewLink(
    viewType: viewType,
    onCreatePlatformView: _createHtmlElementView,
    surfaceFactory: (BuildContext context, PlatformViewController controller) => PlatformViewSurface(
      controller: controller,
      gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
      hitTestBehavior: PlatformViewHitTestBehavior.opaque,
    ),
  );

  _HtmlElementViewControllerEx _createHtmlElementView(PlatformViewCreationParams params) {
    final _HtmlElementViewControllerEx controller = _HtmlElementViewControllerEx(params.id, viewType);
    controller._initialize().then((_) {
      params.onPlatformViewCreated(params.id);
      onPlatformViewCreatedCallback(params.id); //!!!
    });
    return controller;
  }
}

class _HtmlElementViewControllerEx extends PlatformViewController {

  _HtmlElementViewControllerEx(this.viewId, this.viewType);

  @override
  final int viewId;
  final String viewType;
  bool _initialized = false;

  Future<void> _initialize() async {
    await SystemChannels.platform_views.invokeMethod<void>('create', {'id': viewId, 'viewType': viewType});
    _initialized = true;
  }

  @override
  Future<void> clearFocus() {
    return Future.value();
  }

  @override
  Future<void> dispatchPointerEvent(PointerEvent event) {
    return Future.value();
  }

  @override
  Future<void> dispose() {
    if (_initialized) {
      SystemChannels.platform_views.invokeMethod<void>('dispose', viewId);
    }
    return Future.value();
  }
}
