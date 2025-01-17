
import 'package:flutter/cupertino.dart';
import 'package:seekyouapp/data/manager/user_manager.dart';

class InitManager {
  static InitManager _instance;

  InitManager._();

  static InitManager getInstance() {
    if (_instance == null) {
      _instance = InitManager._();
    }
    return _instance;
  }

  void init() {
  }

  void initContext(BuildContext context) async {
    await AccountManager.getInstance().initUser(context);
    if (AccountManager.getInstance().isLogin()) {
      AccountManager.getInstance().refreshFromNet(context);
    }
  }

}