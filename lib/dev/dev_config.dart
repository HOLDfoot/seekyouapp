import 'package:seekyouapp/data/constant/sp_constant.dart';
import 'package:seekyouapp/util/logger.dart';
import 'package:seekyouapp/util/sp_util.dart';

/// 全局的打包配置
class DevConfig {
  static bool inProduction = const bool.fromEnvironment("dart.vm.product");

  /// 全局开关, 标志app是否正在开发中
  static const bool DEBUG = true; // todo zmr

  /// 配置默认的服务器类型
  static const bool _CONFIG_TEST_SERVER = true; // todo zmr 正式上线前要改成 false

  static const String TEST_API = "https://test.quyaxinli.com";
  static const String RELEASE_API = "https://www.quyaxinli.com";
  static String baseApi = isTestServer ? TEST_API : RELEASE_API;
  static bool _setTestServer; // 是否被设置成测试服务器

  static const bool NET_LOG_SWITCH = DEBUG && true;
  static const bool ANDROID_LOG_SWITCH = false; // 通过Android工程打印的
  static const bool FLUTTER_LOG_SWITCH = true; // 优先级高于 ANDROID_LOG_SWITCH

  static get isTestServer {
    /// 判断是否被设置成测试服务器
    /// null/false 代表正式服务器
    return _setTestServer ?? _CONFIG_TEST_SERVER;
  }

  static Future<void> initServerType() async {
    _setTestServer = await SpUtil.getBool(SpConstant.SP_SET_TEST_SERVER);
    baseApi = isTestServer ? TEST_API : RELEASE_API;
    if (DEBUG) {
      Logger.log("initServerType baseApi: " + baseApi);
    }
  }
}
