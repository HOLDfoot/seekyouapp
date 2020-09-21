import 'dart:io';

import 'package:seekyouapp/util/logger.dart';
import 'package:flutter/services.dart';

class GetChannel {
  static const perform = const MethodChannel("get_channel");

  static Future<String> getDeliveryChannel() async {
    if (Platform.isIOS) return "";
    String appChannel;
    try {
      appChannel = await perform.invokeMethod("getDeliveryChannel");
    } on PlatformException catch (e) {
      Logger.E(msg: "getDeliveryChannel e= " + e.message);
    }
    return appChannel;
  }

  /// 获取app内目录, 优先获取扩展存储空间的app目录, 如果获取不到才去获取内部存储空间的目录
  /// type: 1. document 默认, 2. picture
  static Future<String> getAppDirectory({String type = "document"}) async {
    if (Platform.isIOS) return "";
    String appDir;
    try {
      appDir = await perform.invokeMethod("getAppDirectory", {'type': type});
    } on PlatformException catch (e) {
      Logger.E(msg: "getAppDirectory e= " + e.message);
    }
    return appDir;
  }

}
