import 'package:seekyouapp/platform/forandroid/get_channel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DirectoryUtil {
  /// 获取APP内的存储目录
  static Future<String> getDocumentsDirectory() async {
    String documentDir;
    if (Platform.isAndroid) {
      // Android如果使用内部存储目录无法用QQ分享图片
      // documentDir = await getAndroidAppDirectory(); // 还没有完成原生端chanel部分

      documentDir = (await getApplicationDocumentsDirectory()).path;
    } else {
      documentDir = (await getApplicationDocumentsDirectory()).path;
    }
    return documentDir;
  }

  /// 通过Android的channel获取应用内的路径, 优先选择外存的目录
  /// type: 1. document 默认, 2. picture
  static Future<String> getAndroidAppDirectory(
      {String type = "document"}) async {
    String tempPath = await GetChannel.getAppDirectory(type: type);
    return tempPath;
  }

  /// 获取非APP目录需要权限, 通常不用
  static Future<String> getExternalDirectory() async {
    String cardDir = (await getExternalStorageDirectory()).path;
    return cardDir;
  }

  /// 使用有问题
  static Future<String> getTempDirectory() async {
    String tempPath;
    if (Platform.isAndroid) {
      // Android如果使用内部存储目录无法用QQ分享图片
      tempPath = await getAndroidAppDirectory();
    } else {
      tempPath = (await getTemporaryDirectory()).path;
    }
    return tempPath;
  }
}
