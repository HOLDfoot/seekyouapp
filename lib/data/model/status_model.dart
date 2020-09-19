import 'package:seekyouapp/util/logger.dart';

class FirstStatus {
  bool _firstState = true; // 没有调用过默认为true

  bool isFirst() {
    if (_firstState) {
      _firstState = false;
      return true;
    } else {
      return false;
    }
  }
}

class FirstStaticStatus {
  static bool _firstState = true; // 没有调用过默认为true

  static bool isFirst() {
    if (_firstState) {
      _firstState = false;
      return true;
    } else {
      return false;
    }
  }
}

class CounterObject {
  int count = -1;

  CounterObject({this.count = -1});

  /// compareTo至少为0
  bool increaseAndEqualTo(int compareTo) {
    count++;
    Logger.log("increaseAndEqualTo count= " + count.toString());
    if (count == compareTo) {
      return true;
    }
    return false;
  }
}
