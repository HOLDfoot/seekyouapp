import 'package:seekyouapp/dev/dev_config.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:meta/meta.dart';

class Log {
  static bool inProduction = const bool.fromEnvironment("dart.vm.product");
  static bool _debug = DevConfig.FLUTTER_LOG_SWITCH;
  static String _tag = "zmr";

  static void setDebug(bool debug) {
    _debug = debug;
  }

  /// 带tag的打印工具
  static void tPrint(String msg, {String tag = "zmr"}) {
    if (!_debug) return;
    msg = tag + ": " + msg;
    log(msg: msg);
  }

  /// 不带tag的打印工具
  static void purePrint(String msg) {
    if (!_debug) return;
    log(msg: msg);
  }

  /// 带tag的打印工具
  static void tDebug({String tag = "zmr", @required String msg}) {
    if (!_debug) return;
    msg = tag + ": " + msg;
    debugPrint(msg);
  }

  /// 不带tag的打印工具
  /// 如果你一次输出太多，那么Android有时会丢弃一些日志行。为了避免这种情况，您可以使用Flutter的foundation库中的debugPrint()。 这是一个封装print，它将输出限制在一个级别，避免被Android内核丢弃。
  static void debug(String msg) {
    if (!_debug) return;
    debugPrint(msg);
  }

  static void debugPrint(String msg) {
    if (!_debug) return;
    if (_tag != null && msg != null) {
      foundation.debugPrint("$_tag: $msg");
    }
  }

  static void log({String msg = ""}) { // msg为""也能打印
    if (!_debug) return;
    print("$_tag: $msg");
  }
}