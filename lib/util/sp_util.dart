import 'dart:async';

import 'package:seekyouapp/util/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 用来做shared_preferences的存储, 全部都是静态方法
class SpUtil {
  static const String _TAG = "SpUtil";
  static SharedPreferences _spf;

  static Future<bool> _beforeCheck() async {
    if (_spf != null) return true;
    bool initSuccess = false;
    try {
      await _init();
      initSuccess = true;
    } on Exception catch (e) {
      Logger.E(tag: _TAG, msg: "details:\n $e");
    } catch (e, s) {
      Logger.E(tag: _TAG, msg: "details:\n $e");
      Logger.E(tag: _TAG, msg: "Stack trace:\n $s");
    } finally {
      Logger.E(tag: _TAG, msg: "_init");
    }
    return initSuccess;
  }

  static Future<SharedPreferences> _init() async {
    _spf = await SharedPreferences.getInstance();
    return _spf;
  }

  // 判断是否存在数据
  static Future<bool> hasKey(String key) async {
    Set keys = await getKeys();
    return keys.contains(key);
  }

  static Future<Set<String>> getKeys() async {
    if (!await _beforeCheck()) return null;
    return _spf.getKeys();
  }

  static get(String key) async {
    if (!await _beforeCheck()) return null;
    return _spf.get(key);
  }

  static Future<String> getString(String key) async {
    if (!(await _beforeCheck())) return null;
    return _spf.getString(key);
  }

  static Future<bool> putString(String key, String value) async {
    if (!await _beforeCheck()) return null;
    return _spf.setString(key, value);
  }

  static Future<bool> getBool(String key) async {
    if (!await _beforeCheck()) return null;
    return _spf.getBool(key);
  }

  static Future<bool> putBool(String key, bool value) async {
    if (!await _beforeCheck()) return null;
    return _spf.setBool(key, value);
  }

  static Future<int> getInt(String key) async {
    if (!await _beforeCheck()) return null;
    return _spf.getInt(key);
  }

  static Future<bool> putInt(String key, int value) async {
    if (!await _beforeCheck()) return null;
    return _spf.setInt(key, value);
  }

  static Future<double> getDouble(String key) async {
    if (!await _beforeCheck()) return null;
    return _spf.getDouble(key);
  }

  static Future<bool> putDouble(String key, double value) async {
    if (!await _beforeCheck()) return null;
    return _spf.setDouble(key, value);
  }

  static Future<List<String>> getStringList(String key) async {
    return _spf.getStringList(key);
  }

  static Future<bool> putStringList(String key, List<String> value) async {
    if (!await _beforeCheck()) return null;
    return _spf.setStringList(key, value);
  }

  static dynamic getDynamic(String key) async {
    if (!await _beforeCheck()) return null;
    return _spf.get(key);
  }

  static Future<bool> remove(String key) async {
    if (!await _beforeCheck()) return null;
    return _spf.remove(key);
  }

  static Future<bool> clear() async {
    if (!await _beforeCheck()) return null;
    return _spf.clear();
  }
}
