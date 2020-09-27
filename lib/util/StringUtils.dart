
class StringUtils {
  static String join(List list, String separator) {
    String ss = "";
    if (list == null || list.length == 0) {
      return ss;
    }
    for (int i = 0; i < list.length; i++) {
      ss = ss + list[i];
      if (i < list.length - 1) {
        ss = ss + separator;
      }
    }
    return ss;
  }
}
