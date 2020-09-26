import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:seekyouapp/app/routers/router_handler.dart';
import 'package:seekyouapp/main.dart';
import 'package:seekyouapp/ui/page/login_page.dart';
import 'package:seekyouapp/ui/page/setting_page.dart';
import 'package:seekyouapp/ui/page/user/edit_mine_page.dart';

/// 定义
class AppRoutes {
  /// 根界面
  static const String ROUTE_BOTTOM_NAVIGATION_BAR =
      "/bottom/navigation/bar"; // 底部bottomNavigationBar
  static const String ROUTE_HOME = "/"; // 应用首页

  /// 全局可能跳转到的界面
  static const String ROUTE_ERROR_404 = "/error/404"; // 找不到路由的界面
  static const String ROUTE_WEB_VIEW = "/webview"; // webView界面
  static const String ROUTE_OFFICIAL_WEBVIEW =
      "official/webview"; // 使用官方提供的webView插件界面

  /// 开发中加入的测试界面
  static const String ROUTE_DEV_TEST_HELPER = "/dev/test/helper"; // 趣鸭测试助手页面
  static const String ROUTE_DEV_SCREEN = "/dev/screen"; // 测试屏幕的尺寸的界面
  static const String ROUTE_DEV_TEST = "/dev/test"; // 开发中查看测试的界面

  /// 主界面
  static const String ROUTE_MAIN = "/main";

  /// 设置界面
  static const String ROUTE_APP_SETTING = "/setting";
  static const String ROUTE_APP_SETTING_MINE = "/setting/mine";

  /// 登录注册相关界面
  static const String ROUTE_USER_SIGN = "/user/sign";

  static void configureRoutes(Router router) {
    router.notFoundHandler = widgetNotFoundHandler;

    router.define(ROUTE_ERROR_404, handler: widgetNotFoundHandler);
    // router.define(ROUTE_DEV_TEST_HELPER, handler: RouteHandler.create(new QuTesterPage())); // ROUTE_DEV_TEST_HELPER
    // router.define(ROUTE_DEV_SCREEN, handler: RouteHandler.create(new ScreenUtilTest(title: "屏幕测试"))); // ROUTE_DEV_SCREEN

    router.define(ROUTE_MAIN, handler: create(new BottomWidget()));

    router.define(ROUTE_APP_SETTING, handler: create(new SettingPage()));
    router.define(ROUTE_APP_SETTING_MINE, handler: create(new EditMinePage()));
    router.define(ROUTE_USER_SIGN, handler: create(new LoginPage()));

  }

  static Handler create(Widget widget) {
    return new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return widget;
    });
  }
}

// typedef Widget PageCreateFunc(Map<String, List<String>> params);

// class RouteHandler {
//   static Handler createMoodPage() {
//     return null;
//   }
//
//   static Handler createPage(PageCreateFunc createFunc) {
//     return new Handler(
//         handlerFunc: (BuildContext context, Map<String, List<String>> params) {
//       return createFunc(params);
//     });
//   }
//
//   static Handler create(Widget widget) {
//     return new Handler(
//         handlerFunc: (BuildContext context, Map<String, List<String>> params) {
//       return widget;
//     });
//   }
// }
