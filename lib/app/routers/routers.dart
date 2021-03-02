import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:seekyouapp/app/routers/router_handler.dart';
import 'package:seekyouapp/main.dart';
import 'package:seekyouapp/ui/page/list/vertical_page_view.dart';
import 'package:seekyouapp/ui/page/login_page.dart';
import 'package:seekyouapp/ui/page/mine_intent_page.dart';
import 'package:seekyouapp/ui/page/setting/contact_author.dart';
import 'package:seekyouapp/ui/page/setting/edit_hobby_page.dart';
import 'package:seekyouapp/ui/page/setting/edit_intro_page.dart';
import 'package:seekyouapp/ui/page/setting/edit_mine_page.dart';
import 'package:seekyouapp/ui/page/setting_page.dart';

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

  /// 登录注册相关界面
  static const String ROUTE_USER_SIGN = "/user/sign";

  /// 设置界面
  static const String ROUTE_SETTING = "/setting";
  static const String ROUTE_SETTING_MINE = "/setting/mine";
  static const String ROUTE_SETTING_MINE_DESC = "/setting/mine/desc";
  static const String ROUTE_SETTING_MINE_HOBBIES = "/setting/mine/hobbies";
  static const String ROUTE_SETTING_AUTHOR = "/setting/author";
  static const String ROUTE_USER_VERTICAL = "/user/vertical";

  static const String ROUTE_MINE_INTENT = "/mine/intent";

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = widgetNotFoundHandler;

    router.define(ROUTE_ERROR_404, handler: widgetNotFoundHandler);
    // router.define(ROUTE_DEV_TEST_HELPER, handler: RouteHandler.create(new QuTesterPage())); // ROUTE_DEV_TEST_HELPER
    // router.define(ROUTE_DEV_SCREEN, handler: RouteHandler.create(new ScreenUtilTest(title: "屏幕测试"))); // ROUTE_DEV_SCREEN

    router.define(ROUTE_MAIN, handler: createHandler(new BottomWidget()));

    router.define(ROUTE_USER_SIGN, handler: createHandler(new LoginPage()));

    router.define(ROUTE_SETTING, handler: createHandler(new SettingPage()));
    router.define(ROUTE_SETTING_MINE, handler: createHandler(new EditMinePage()));
    router.define(ROUTE_MINE_INTENT, handler: createHandler(new MineIntentPage()));


    router.define(ROUTE_SETTING_MINE_DESC, handler: createParamHandler((_) {
      return EditIntroPage(pageParam: _);
    }));
    router.define(ROUTE_SETTING_MINE_HOBBIES, handler: createParamHandler((_) {
      return EditHobbyPage(pageParam: _);
    }));
    router.define(ROUTE_SETTING_AUTHOR, handler: createHandler(new ContactAuthorPage()));
    router.define(ROUTE_USER_VERTICAL, handler: createParamHandler((_) {
      return VerticalViewPage(pageParam: _);
    }));

  }

  static Handler createHandler(Widget widget) {
    return new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return widget;
    });
  }

  static Handler createParamHandler(PageCreateFunc pageCreateFunc) {
    return new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return pageCreateFunc(params);
    });
  }
}

typedef Widget PageCreateFunc(Map<String, List<String>> params);

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
