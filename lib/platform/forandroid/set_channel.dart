import 'dart:io';

import 'package:seekyouapp/util/logger.dart';
import 'package:flutter/services.dart';

class SetChannel {
  static const perform = const MethodChannel("set_channel");

  static void setNoticePerm() async {
    if (Platform.isIOS) return;
    try {
      await perform.invokeMethod("setNoticePermMethod");
    } on PlatformException catch (e) {
      Logger.E(msg: "setNoticePerm e= " + e.message);
    }
  }
}
