import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seekyouapp/app/provider/UserProvider.dart';
import 'package:seekyouapp/app/routers/navigate.dart';
import 'package:seekyouapp/app/routers/routers.dart';
import 'package:seekyouapp/data/constant/sp_constant.dart';
import 'package:seekyouapp/data/manager/user.dart';
import 'package:seekyouapp/data/manager/cache_manager.dart';
import 'package:seekyouapp/net/api/app_api.dart';
import 'package:seekyouapp/util/logger.dart';
import 'package:seekyouapp/util/sp_util.dart';
import 'package:seekyouapp/util/toast_util.dart';

class AccountManager {
  static AccountManager _instance;

  AccountManager._();
  User _user;
  bool _isInit = false;

  static AccountManager getInstance() {
    if (_instance == null) {
      _instance = AccountManager._();
    }
    return _instance;
  }

 void refreshFromNet(BuildContext context) async{
    ResultData resultData = await AppApi.getInstance().getUserMine(context);
    if (resultData.isSuccess()) {
      User user = User.fromJson(resultData.data);
      cacheUser(user);
    } else if (resultData.code == 500500 || resultData.result) { /// token失效, 或者服务端的其他网络正常返回结果
     logOut(notifyServer: false);
     AppController.navigateTo(context, AppRoutes.ROUTE_USER_SIGN);
    }
  }

  User getUser() {
    return _user;
  }

  bool isLogin() {
    return _user != null;
  }

  /// 通知服务器退出用户登录, 如果因为服务端导致的token过期, notifyServer为false
  logOut({bool notifyServer = true}) {
    if (notifyServer) {
      /// 在userId置空之前获取参数
      logOutOnServer(null);
    }
    _user = null;
    SpUtil.putString(SpConstant.SP_USER_INFO, "");
    CacheManager.getInstance().clearCache();
    clearSdkUser();
  }

  /// 用户注册/登录后, 更新用户信息(sdk/内存/外存)
  logIn(BuildContext context, User user) {
    cacheUser(user);
    setSdkUser();
    notifyUserOnUi(context);
  }

  /// 解决provider初始化完成后还没有成功读取user的问题
  void notifyUserOnUi(BuildContext context) {
    context.read<UserProvider>().updatePhoto(_user.userPhoto);
    context.read<UserProvider>().updateUser(_user);
  }

  /// 用户已登录情况下启动App过程中, 更新用户信息(sdk)
  doWhenAlreadyLogin() {
    setSdkUser();
  }

  /// 刷新内存和外存的用户信息
  cacheUser(User user) {
    _user = user;
    String userStr = json.encode(user);
    SpUtil.putString(SpConstant.SP_USER_INFO, userStr);
  }

  logOutOnServer(BuildContext context) {
    Map<String, String> param = getUserParam();
    //AppApi.getInstance().logOut(context, param);
  }

  Future<User> initUser(BuildContext context) async {
    //if (_user != null) return;
    if (_isInit) return _user;
    String userStr = await SpUtil.getString(SpConstant.SP_USER_INFO);
    if (!ObjectUtil.isEmpty(userStr)) {
      Logger.log("userStr= " + userStr);
      _user = User.fromJson(json.decode(userStr));

      notifyUserOnUi(context);
      doWhenAlreadyLogin();
    } else {
      Logger.log("userStr= " + "null");
    }
    _isInit = true;
    return _user;
  }

  bool isInit() {
    return _isInit;
  }

  String getUserId() {
    if (isLogin()) {
      return _user.userId;
    } else {
      return null;
    }
  }

  Map<String, String> getUserParam() {
    Map<String, String> userParam = {};
    if (isLogin()) {
      userParam["userId"] = _user.userId;
      userParam["userToken"] = _user.userToken;
    }
    return userParam;
  }

  /// 是否是管理人员
  bool isManager() {
    return false;
  }

  /// 是否是测试人员
  bool isQuTester() {
    return false;
  }

  /// 关联第三方sdk的userId
  void setSdkUser() {
  }

  /// 清除第三方sdk的userId
  void clearSdkUser() {
  }

  void updateUser(BuildContext context, User user) {
    _user = user;
    // 发起User更新通知
    //Provider.of<User>(context).userPhoto = user.userPhoto;
  }
}
