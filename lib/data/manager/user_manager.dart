import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:seekyouapp/data/constant/sp_constant.dart';
import 'package:seekyouapp/data/manager/user.dart';
import 'package:seekyouapp/data/manager/cache_manager.dart';
import 'package:seekyouapp/net/api/app_api.dart';
import 'package:seekyouapp/util/logger.dart';
import 'package:seekyouapp/util/sp_util.dart';

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

  refreshFromNet(BuildContext context) async{
    User user = await AppApi.getInstance().getUserInfo(context);
    if (user != null) {
      cacheUser(user);
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
  logIn(User user) {
    cacheUser(user);
    setSdkUser();
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

  Future<void> init() async {
    //if (_user != null) return;
    if (_isInit) return;
    String userStr = await SpUtil.getString(SpConstant.SP_USER_INFO);
    if (!ObjectUtil.isEmpty(userStr)) {
      Logger.log("userStr= " + userStr);
      _user = User.fromJson(json.decode(userStr));
      doWhenAlreadyLogin();
    } else {
      Logger.log("userStr= " + "null");
    }
    _isInit = true;
  }

  bool isInit() {
    return _isInit;
  }

  getUserId() {
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
      userParam["apiToken"] = _user.userToken;
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
}
