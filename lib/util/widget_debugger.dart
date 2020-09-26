import 'package:flutter/material.dart';
import 'package:seekyouapp/util/logger.dart';

class WidgetDebugger {

  final GlobalKey _globalKey = GlobalKey();

  void printWidthHeight () {
    if (globalKey.currentContext != null) {
      final width = globalKey.currentContext.size.width;
      final height = globalKey.currentContext.size.height;
      String log = 'Widget width is $width, height is $height';
      Logger.log(log);
    }
  }

  GlobalKey get globalKey => _globalKey;
}