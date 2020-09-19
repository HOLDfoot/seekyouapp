import 'dart:io';

import 'package:seekyouapp/dev/dev_config.dart';
import 'package:seekyouapp/dev/developer_config.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class Logger {
  static bool inProduction = const bool.fromEnvironment("dart.vm.product");
  static const perform = const MethodChannel("android_log");
  static bool _debugAndroid = DevConfig.ANDROID_LOG_SWITCH && Platform.isAndroid; // 使用须知: _debugFlutter is false & _debugAndroid is true
  static bool _debugFlutter = DevConfig.FLUTTER_LOG_SWITCH; // 优先级比较高, 如果true, 则只打印flutter的log
  static const String _TAG = DeveloperConfig.DeveloperTAG;

  static void setDebug(bool debug) { // 需要强制打开日志开关的时候调用
    debugPrint("Logger setDebug debug= " + debug.toString());
    _debugFlutter = debug;
  }

  Logger(this._tag);
  String _tag; 
  /// 不需要tag, 但需要单独实例化后才能调用的打印工具
  void v(String msg) {
    if (_debugFlutter) {
      loggerPrint(msg);
      return;
    }
    if (!_debugAndroid) return;
    perform.invokeMethod('logV', {'tag': _tag, 'msg': msg});
  }

  void d(String msg) {
    if (_debugFlutter) {
      loggerPrint(msg);
      return;
    }
    if (!_debugAndroid) return;
    perform.invokeMethod('logD', {'tag': _tag, 'msg': msg});
  }

  void i(String msg) {
    if (_debugFlutter) {
      loggerPrint(msg);
      return;
    }
    if (!_debugAndroid) return;
    perform.invokeMethod('logI', {'tag': _tag, 'msg': msg});
  }

  void w(String msg) {
    if (_debugFlutter) {
      loggerPrint(msg);
      return;
    }
    if (!_debugAndroid) return;
    perform.invokeMethod('logW', {'tag': _tag, 'msg': msg});
  }

  void e(String msg) {
    if (_debugFlutter) {
      loggerPrint(msg);
      return;
    }
    if (!_debugAndroid) return;
    perform.invokeMethod('logE', {'tag': _tag, 'msg': msg});
  }

  ///不需要单独实例化后就能调用的打印工具
  static void V({String tag = _TAG, @required String msg}) {
    if (_debugFlutter) {
      debugPrint(msg);
      return;
    }
    if (!_debugAndroid) return;
    perform.invokeMethod('logV', {'tag': tag, 'msg': msg});
  }

  static void D({String tag = _TAG, @required String msg}) {
    if (_debugFlutter) {
      debugPrint(msg);
      return;
    }
    if (!_debugAndroid) return;
    perform.invokeMethod('logD', {'tag': tag, 'msg': msg});
  }

  static void I({String tag = _TAG, @required String msg}) {
    if (_debugFlutter) {
      debugPrint(msg);
      return;
    }
    if (!_debugAndroid) return;
    perform.invokeMethod('logI', {'tag': tag, 'msg': msg});
  }

  static void W({String tag = _TAG, @required String msg}) {
    if (_debugFlutter) {
      debugPrint(msg);
      return;
    }
    if (!_debugAndroid) return;
    perform.invokeMethod('logW', {'tag': tag, 'msg': msg});
  }

  static void E({String tag = _TAG, @required String msg}) {
    if (_debugFlutter) {
      debugPrint(msg);
      return;
    }
    if (!_debugAndroid) return;
    perform.invokeMethod('logE', {'tag': tag, 'msg': msg});
  }

  ///不需要传递tag就能调用的打印工具
  static void log(String msg) {
    if (_debugFlutter) {
      debugPrint(msg);
      return;
    }
    if (!_debugAndroid) return;
    perform.invokeMethod('logD', {'tag': _TAG, 'msg': msg});
  }

  static void debugPrint(String msg) {
    if (_TAG != null && msg != null) {
      foundation.debugPrint("$_TAG: $msg");
    }
  }

  void loggerPrint(String msg) {
    if (_tag != null && msg != null) {
      foundation.debugPrint("$_tag: $msg");
    }
  }
}
