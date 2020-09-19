library basicnetservice;
export 'package:seekyouapp/net/service/net_service.dart';
import 'package:flutter/widgets.dart';
import 'package:seekyouapp/data/manager/user.dart';
import 'package:seekyouapp/net/service/net_service.dart';

import 'app_net_service.dart';


class AppApi extends AppNetService {

  /// 获取天气的接口
  static const String _GET_WEATHER = "/";
  static const String _SIGN_UP = "/signup";
  static const String _SIGN_IN = "/signin";
  static const String _GET_USER_INFO = "/api/get_user_info";

  AppApi._();
  static AppApi _instance;
  static AppApi getInstance() {
    if (_instance == null) {
      _instance = AppApi._();
    }
    return _instance;
  }

  Future<User> getUserInfo(BuildContext context) async {
    ResultData resultData = await post(_GET_USER_INFO);
    User user;
    if (!resultData.isFail()) {
      user = User.fromJson(resultData.data);
    }
    return user;
  }

  Future<ResultData> getWeather(BuildContext context, bool showProgress) async {
    Map<String, dynamic> param = {};
    ///?app=weather.future&weaid=1&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json
    param["app"] = "weather.future";
    param["weaid"] = "1";
    param["appkey"] = "10003";
    param["sign"] = "b59bc3ef6191eb9f747dd4e83c99f2a4";
    param["format"] = "json";
    ResultData resultData =
    await get(_GET_WEATHER, params: param, context: context, showLoad: showProgress);
    resultData.toast();
    return resultData;
  }

  Future<ResultData> signUp(BuildContext context, bool showProgress, Map<String, dynamic> param) async {
    ResultData resultData =
    await get(_SIGN_UP, params: param, context: context, showLoad: showProgress);
    resultData.toast();
    return resultData;
  }

  Future<ResultData> signIn(BuildContext context, bool showProgress, Map<String, dynamic> param) async {
    ResultData resultData =
    await get(_SIGN_IN, params: param, context: context, showLoad: showProgress);
    resultData.toast();
    return resultData;
  }

}
