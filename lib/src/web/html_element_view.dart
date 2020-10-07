import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// https://github.com/deakjahn/flutter_dropzone
// https://github.com/flutter/flutter/issues/56181

class HtmlElementViewEx extends HtmlElementView {
  final PlatformViewCreatedCallback onPlatformViewCreated; //!!!
  final dynamic creationParams;

  const HtmlElementViewEx({Key key, @required String viewType, this.onPlatformViewCreated, this.creationParams}) : super(key: key, viewType: viewType);

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
      onPlatformViewCreated(params.id); //!!!
    });
    return controller;
  }
}

class _HtmlElementViewControllerEx extends PlatformViewController {
  @override
  final int viewId;
  final String viewType;
  bool _initialized = false;

  _HtmlElementViewControllerEx(this.viewId, this.viewType);

  Future<void> _initialize() async {
    await SystemChannels.platform_views.invokeMethod<void>('create', {'id': viewId, 'viewType': viewType});
    _initialized = true;
  }

  @override
  Future<void> clearFocus() {
    return null;
  }

  @override
  Future<void> dispatchPointerEvent(PointerEvent event) {
    return null;
  }

  @override
  Future<void> dispose() {
    if (_initialized) SystemChannels.platform_views.invokeMethod<void>('dispose', viewId);
    return null;
  }
}