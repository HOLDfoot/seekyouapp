library basicnetservice;

export 'package:seekyouapp/net/service/net_service.dart';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:seekyouapp/data/manager/user.dart';
import 'package:seekyouapp/net/model/user_list_data.dart';
import 'package:seekyouapp/net/service/net_service.dart';
import 'package:seekyouapp/net/widget/dialog_param.dart';
import 'package:seekyouapp/net/widget/loading_dialog.dart';
import 'package:seekyouapp/util/toast_util.dart';

import 'app_net_service.dart';

class AppApi extends AppNetService {
  /// 获取天气的接口
  static const String _GET_WEATHER = "/";
  static const String _SIGN_UP = "/signup";
  static const String _SIGN_IN = "/signin";
  static const String _GET_USER_MINE = "/get_user_mine";
  static const String _UPLOAD_USER_ICON = "/upload_photo";
  static const String _UPDATE_USER = "/update_user";
  static const String _GET_USER_ALL = "/get_user_all";
  static const String _UPDATE_MINE_INTENT = "/update_user_intent";
  static const String _GET_USER_INTENT = "/get_user_intent";
  static const String _UPDATE_LIKE_USER = "/update_like_user";
  static const String _UPDATE_HATE_USER = "/update_hate_user";
  static const String _REPORT_USER = "/report_user";
  static const String _GET_USER_PREFERENCE = "/get_user_preference";

  AppApi._();

  static AppApi _instance;

  static AppApi getInstance() {
    if (_instance == null) {
      _instance = AppApi._();
    }
    return _instance;
  }

  Future<ResultData> getUserMine(BuildContext context) async {
    ResultData resultData = await get(_GET_USER_MINE);
    resultData.toast();
    return resultData;
  }

  Future<ResultData> getWeather(BuildContext context, bool showProgress) async {
    Map<String, dynamic> param = {};

    ///?app=weather.future&weaid=1&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json
    param["app"] = "weather.future";
    param["weaid"] = "1";
    param["appkey"] = "10003";
    param["sign"] = "b59bc3ef6191eb9f747dd4e83c99f2a4";
    param["format"] = "json";
    ResultData resultData = await get(_GET_WEATHER,
        params: param, context: context, showLoad: showProgress);
    resultData.toast();
    return resultData;
  }

  Future<ResultData> signUp(BuildContext context, bool showProgress,
      Map<String, dynamic> param) async {
    ResultData resultData = await get(_SIGN_UP,
        params: param, context: context, showLoad: showProgress);
    resultData.toast();
    return resultData;
  }

  Future<ResultData> signIn(BuildContext context, bool showProgress,
      Map<String, dynamic> param) async {
    ResultData resultData = await get(_SIGN_IN,
        params: param, context: context, showLoad: showProgress);
    resultData.toast();
    return resultData;
  }

  /// 上传头像接口
  Future<ResultData> uploadUserIcon(BuildContext context, File file) async {
    // 开始进度
    ShowParam showParam =
        new ShowParam(barrierDismissible: true, showBackground: true);
    showParam.text = "正在上传头像...";
    LoadingDialogUtil.showTextLoadingDialog(context, showParam);
    String fileName = file.path.substring(file.path.lastIndexOf("/") + 1);
    print("filename: $fileName");
    List<int> bytes = await file.readAsBytes();
    ResultData resultData = await upLoad(file, fileName, _UPLOAD_USER_ICON);
    showParam.pop();
    // 结束进度
    resultData.toast();
    return resultData;
  }

  Future<ResultData> updateUser(BuildContext context, bool showProgress,
      Map<String, dynamic> param) async {
    ResultData resultData = await post(_UPDATE_USER,
        params: param, context: context, showLoad: showProgress);
    resultData.toast();
    return resultData;
  }

  /// 获取所有用户的信息
  Future<List<User>> getUserAll(BuildContext context, int pageNum, {int pageSize = 20}) async {
    Map<String, dynamic> param = {
      "pageNum": pageNum,
      "pageIndex": pageSize,
    };
    ResultData resultData = await get(_GET_USER_ALL, params: param);
    List<User> userList;
    if (!resultData.isFail()) {
      userList = UserListData.fromJson(resultData.data).modelList;
    }
    return userList;
  }

  Future<ResultData> updateMineIntent(BuildContext context, bool showProgress,
      Map<String, dynamic> param) async {
    ResultData resultData = await post(_UPDATE_MINE_INTENT,
        params: param, context: context, showLoad: showProgress);
    resultData.toast();
    return resultData;
  }

  Future<ResultData> getUserIntent(BuildContext context, bool showProgress, {String theUserId}) async {
    Map<String, dynamic> param = {
      "theUserId": theUserId
    };
    ResultData resultData = await get(_GET_USER_INTENT, context: context, showLoad: showProgress, params: param);
    resultData.toast();
    return resultData;
  }

  Future<ResultData> updateLikeUser(BuildContext context, bool showProgress, {bool likeUser, String theUserId}) async {
    Map<String, dynamic> param = {
      "likeUser": likeUser,
      "theUserId": theUserId
    };
    ResultData resultData = await post(_UPDATE_LIKE_USER,
        params: param, context: context, showLoad: showProgress);
    resultData.toast();
    return resultData;
  }

  Future<ResultData> hateUser(BuildContext context, bool showProgress, {String theUserId}) async {
    Map<String, dynamic> param = {
      "theUserId": theUserId
    };
    ResultData resultData = await post(_UPDATE_HATE_USER,
        params: param, context: context, showLoad: showProgress);
    resultData.toast();
    return resultData;
  }

  /// 举报该用户
  Future<ResultData> reportUser(BuildContext context, bool showProgress, {String theUserId, String reportText}) async {
    Map<String, dynamic> param = {
      "theUserId": theUserId,
      "reportText": reportText
    };
    ResultData resultData = await post(_REPORT_USER,
        params: param, context: context, showLoad: showProgress);
    resultData.toast();
    return resultData;
  }

  Future<ResultData> getUserPreference(BuildContext context, {String theUserId}) async {
    Map<String, dynamic> param = {
      "theUserId": theUserId,
    };
    ResultData resultData = await get(_GET_USER_PREFERENCE, params: param);
    resultData.toast();
    return resultData;
  }
}
