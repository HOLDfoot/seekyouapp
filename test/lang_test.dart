import "package:test/test.dart";

void main() {
  setUp(() async {
    print("test setUp");
  });

  tearDown(() async {
    print("test tearDown");
  });

  test("List序列化", () async {
    List list = List();
    list.add("hello0");
    list.add("hello1");
    list.insert(0, "insert0");
    print(list.toString());
    String ss = StringUtils.join(list, ",");
    print(ss);
    print(list[0]);
  });

  test('数组 lang测试', () async {
    List list = List();
    list.add("hello0");
    list.add("hello1");
    list.insert(0, "insert0");
    print(list.toString());
  });

  test('数组对象 lang测试', () async {
    List<ListItem> list = new List();
    print(list.hashCode);
    list.add(ListItem(11, "xiaohong"));
    list.add(ListItem(22, "xiaoming"));
    list.insert(0, ListItem(00, "xiaoli"));
    print(list.toString());
    print(list.hashCode);

    ListItem item = list[1];
    item.name = "xiaowang";

    print(item);
    print(list.toString());
  });

  test('"\$"null 使用测试', () async {
    print('start null');
    bool isNull = null;
    print("isNull: $isNull");
  });

  test('"\$"Map遍历 使用测试', () async {
    Map<String, String> headers = {};
    headers["deviceBrand"] = "deviceBrand";
    headers["deviceModel"] = "deviceModel";
    headers["sysVersion"] = "sysVersion";
    headers["appVersion"] = "";
    headers["appDeliveryChannel"] = null;
    print("headers len: ${headers.length}");
    headers.removeWhere((key, value) {
      return (value == null || value == "");
    });
    print("after remove headers len: ${headers.length}");
    headers.forEach((key, value) {
      print("====================");
      print("key: $key, value: $value");
    });
  });

  test('"range 使用测试', () async {
    for (var i in range(5)) {
      print(i);
    }
    for (var i in range(5, start: 1, step: 1)) {
      print(i);
    }
    for (var i in range(5, start: 1, step: 2)) {
      print(i);
    }
  });

  test('List const 使用测试', () async {
    List dragItemList = const [];
    try {
      dragItemList.add("Hello");
    } catch (e) {
      print(e);
    }
    print(dragItemList.length);
    expect(dragItemList.length, 1);
  });

  test('as double 使用测试', () async {
    int a = 1;
    double b;
    bool except = false;
    try {
      b = a as double;
    } catch (e) {
      except = true;
      print(e); // type 'int' is not a subtype of type 'double' in type cast
    }
    expect(except, true);
    b = a.toDouble();
    a = null;
    b = a as double;
  });
}

/// 内置的range方法
range(int stop, {int start: 0, int step: 1}) {
  if (step == 0) throw Exception("Step cannot be 0");

  return start < stop == step > 0
      ? List<int>.generate(
          ((start - stop) / step).abs().ceil(), (int i) => start + (i * step))
      : [];
}

class ListItem {
  int id;
  String name;

  ListItem(this.id, this.name);

  @override
  String toString() {
    return "{id:$id,name:$name}";
  }
}

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
