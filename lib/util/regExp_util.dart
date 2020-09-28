/// 参考网址
/// https://www.cnblogs.com/ckAng/p/10531562.html
class CharUtil {
  /// 是否是中国的手机号
  static bool isChinaPhoneLegal(String str) {
    if (str == null) return false;
    return new RegExp('^1\\d{10}\$').hasMatch(str);
  }

  /// 是否包含数字字母
  static bool isOnlyChar(String str) {
    return new RegExp('^[a-zA-Z0-9]+\$').hasMatch(str);
  }
}
