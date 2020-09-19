import 'dart:io';

import 'package:package_info/package_info.dart';

/// flutter工程配置的环境常量
class ProjectConstant {
  static const String DEFAULT_VERSION = "1.0.0";
  static const String DEFAULT_CHANNEL = "";
  static const String IOS_CHANNEL = "appStore";
  static String _appVersion = DEFAULT_VERSION;
  static String _appDeliveryChannel = DEFAULT_CHANNEL;
  static String _appBuildNumber = "10000";
  static bool _isInit = false;

  static void init() async {
    if (_isInit) return;
    _isInit = true;
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      _appBuildNumber = packageInfo.buildNumber;
      _appVersion = packageInfo.version;
    });
  }

  static retAppVersion() {
    return _appVersion;
  }

  static retAppBuildNumber() {
    return _appBuildNumber;
  }

}
