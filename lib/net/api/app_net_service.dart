
library basicnetservice;
export 'package:seekyouapp/net/service/net_service.dart';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:seekyouapp/data/manager/user_manager.dart';
import 'package:seekyouapp/net/service/net_service.dart';
import 'package:seekyouapp/net/widget/dialog_param.dart';
import 'package:seekyouapp/net/widget/loading_dialog.dart';

class AppNetService extends NetService {

  AppNetService();

  @override
  request(String url, {Method method, Map<String, dynamic> params, var file, String fileName,String fileSavePath, BuildContext context, bool showLoad = false}) async {
    /// 传参进行统一处理, 加上基本参数
    Map<String, dynamic> basicParam = await getBasicParam();
    basicParam["timeStamp"] = (new DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    if (params != null) {
      basicParam.addAll(params);
    }
    basicParam.addAll(AccountManager.getInstance().getUserParam());
    ShowParam showParam = new ShowParam(show: showLoad, barrierDismissible: false, showBackground: false);
    LoadingDialogUtil.showLoadingDialog(context, showParam);
    ResultData resultData = await super.request(url,method: method, params: basicParam, file: file, fileName: fileName,fileSavePath: fileSavePath);
    showParam.pop();

    /// 当apiToken 过期或者错误时的提示码
    if ("0" == resultData.code && context != null) {
      // 退出登录并跳转到登录界面
      //App.navigateTo(context, QuRoutes.ROUTE_MINE_LOGIN, clearStack: true);
    }

    return resultData;
  }

  @override
  getBasicUrl() {
    //return "http://api.k780.com:88";
    //return "http://172.104.72.105:8081";
    return "http://192.168.0.104:8081";
  }

  @override
  getHeaders() async{
    // TODO: implement getHeaders
    Map<String, dynamic> headers;
    return headers;
  }

  Future<Map<String, dynamic>> getBasicParam() async {
    Map<String, dynamic> basicParam = {};
    basicParam["agent"] = Platform.isAndroid ? "android" : "ios";
    return basicParam;
  }
}
