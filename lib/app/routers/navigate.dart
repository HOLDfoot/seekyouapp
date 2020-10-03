import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:seekyouapp/util/logger.dart';

class AppController {
  static Router _router;

  static set router(router) => _router = router;

  static get router => _router;

  static Future navigateTo(BuildContext context, String path,
      {bool replace = false,
      bool clearStack = false,
      TransitionType transition = TransitionType.inFromRight,
      Duration transitionDuration = const Duration(milliseconds: 250),
      RouteTransitionsBuilder transitionBuilder}) {
    return _router.navigateTo(context, path,
        replace: replace, clearStack: clearStack, transition: transition);
  }

  static Future withParam(BuildContext context, String path,
      {Map<String, dynamic> params,
      bool replace = false,
      bool clearStack = false,
      TransitionType transition = TransitionType.inFromRight,
      Duration transitionDuration = const Duration(milliseconds: 250),
      RouteTransitionsBuilder transitionBuilder}) {
    String query = "";
    if (params != null) {
      int index = 0;
      for (var key in params.keys) {
        var value = Uri.encodeComponent(params[key]);
        if (index == 0) {
          query = "?";
        } else {
          query = query + "\&";
        }
        query += "$key=$value";
        index++;
      }
    }
    Logger.log('我是navigateTo传递的参数：$query');

    path = path + query;
    return _router.navigateTo(context, path,
        replace: replace, clearStack: clearStack, transition: transition);
  }
}
