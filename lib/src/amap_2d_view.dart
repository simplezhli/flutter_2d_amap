
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2d_amap/src/interface/amap_2d_controller.dart';

import 'poisearch_model.dart';

import 'amap_2d_view_state.dart'
    if (dart.library.html) 'web/amap_2d_view_state.dart'
    if (dart.library.io) 'mobile/amap_2d_view_state.dart';

typedef AMap2DViewCreatedCallback = void Function(AMap2DController controller);

class AMap2DView extends StatefulWidget {
  
  const AMap2DView({
    Key key,
    this.isPoiSearch: true,
    this.onPoiSearched,
    this.onAMap2DViewCreated,
    this.webKey,
  }) :super(key: key);
  
  final bool isPoiSearch;
  final AMap2DViewCreatedCallback onAMap2DViewCreated;
  final Function(List<PoiSearch>) onPoiSearched;
  final String webKey;
  
  @override
  AMap2DViewState createState() => AMap2DViewState();
}

