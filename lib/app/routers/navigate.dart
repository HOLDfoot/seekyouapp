import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

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
    return _router.navigateTo(context, path,replace: replace,clearStack: clearStack, transition: transition);
  }
}
