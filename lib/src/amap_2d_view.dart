
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2d_amap/src/interface/amap_2d_controller.dart';

import 'amap_2d_view_state.dart'
if (dart.library.html) 'web/amap_2d_view_state.dart'
if (dart.library.io) 'mobile/amap_2d_view_state.dart';

import 'poi_search_model.dart';


typedef AMap2DViewCreatedCallback = void Function(AMap2DController controller);

class AMap2DView extends StatefulWidget {
  
  const AMap2DView({
    Key? key,
    this.isPoiSearch = true,
    this.onPoiSearched,
    this.onAMap2DViewCreated,
  }) : super(key: key);
  
  final bool isPoiSearch;
  final AMap2DViewCreatedCallback? onAMap2DViewCreated;
  final Function(List<PoiSearch>)? onPoiSearched;

  @override
  AMap2DViewState createState() => AMap2DViewState();
}

