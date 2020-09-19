import 'package:seekyouapp/dev/dev_config.dart';

/// 每个开发人员自己的配置, 如果没有字段删减, 不需要提交到服务器
/// 本文件同步后需要单独通过.gitignore配置, 多个人可以不一样
class DeveloperConfig {

  /// 当前开发人员正在开发中
  static const bool _DEV_ING = false;

  static const String NETWORK_PROXY_IP = "192.168.1.29:8888"; // ZMR's macbook in CECE-5-2
  /// 如果打开该开关, 当且仅当在wifi下网络可用
  static const bool NETWORK_PROXY_OPEN = DevConfig.DEBUG && _DEV_ING;
  /// 当前开发人员自己指定的TAG
  static const String DeveloperTAG = "ZMR";

}