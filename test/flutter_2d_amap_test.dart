import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_2d_amap');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Flutter2dAmap.platformVersion, '42');
  });
}
