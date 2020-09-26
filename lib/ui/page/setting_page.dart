import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seekyouapp/app/routers/navigate.dart';
import 'package:seekyouapp/app/routers/routers.dart';
import 'package:seekyouapp/data/manager/user_manager.dart';
import 'package:seekyouapp/ui/base/base_state_widget.dart';
import 'package:seekyouapp/ui/widget/method_util.dart';
import 'package:seekyouapp/util_set.dart';

class SettingPage extends BaseStatefulPage {
  String title;

  SettingPage({this.title});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends BaseState<SettingPage> {
  bool _showTestHelper = false;
  static const int MAX_CLICK_TIMES = 5;
  int _clickStampMillis = 0;

  /// 3秒内点击5次
  int _clickTimes = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backActionAppbar(context, "设置", _action()),
      backgroundColor: Color(0xFFF3F5F9),
      body: _body(),
    );
  }

  /// 当用户3秒内点击5次的时候, 才显示测试助手按钮
  _action() {
    if (AccountManager.getInstance().isQuTester() && _showTestHelper) {
      return Container(
        width: adapt(80),
        height: adapt(25),
        margin: EdgeInsets.only(right: 10),
        child: RaisedButton(
          child: Text(
            "测试助手",
            style: TextStyle(fontSize: 14, color: Color(0xFF222222)),
          ),
          disabledColor: Color(0xffeeeeee),
          disabledTextColor: Color(0xff999999),
          padding: EdgeInsets.all(0),

          /// 默认padding影响宽度
          color: Color(0xFFFFD511),
          onPressed: () {
            /// 跳转到测试详情界面
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(adapt(5))),
        ),
      );
    } else if (!AccountManager.getInstance().isQuTester()) {
      return Container();
    } else {
      return Container(
        width: adapt(80),
        height: adapt(40),
        //color: Colors.red,
        child: InkWell(
          onTap: () {
            /// 仅当测试用户判断是否点击
            if (!AccountManager.getInstance().isQuTester()) return;
            int nowMillis = DateTime.now().millisecondsSinceEpoch;
            int subtract = nowMillis - _clickStampMillis;
            if (subtract > 3000) {
              _clickStampMillis = nowMillis;
              _clickTimes = 1;
            } else {
              _clickTimes++;
            }
            if (_clickTimes >= MAX_CLICK_TIMES) {
              setState(() {
                _showTestHelper = true;
              });
            }
          },
        ),
      );
    }
  }

  _body() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
              height: adapt(1),
              child: Container(
                height: adapt(1),
              )),
          InkWell(
            child: Container(
              color: Theme.of(context).cardColor,
              height: adapt(48),
              padding: EdgeInsets.only(left: adapt(15), right: adapt(20)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text("个人信息",
                        style: TextStyle(
                          fontSize: sp(16),
                          fontWeight: FontWeight.normal,
                        )),
                  ),
                  Image.asset(
                    'assets/images/ic_black_right_arrow_8_14.png',
                    fit: BoxFit.contain,
                    width: adapt(8),
                    height: adapt(14),
                  ),
                ],
              ),
            ),
            onTap: () {
              /// 个人信息
              AppController.navigateTo(context, AppRoutes.ROUTE_APP_SETTING_MINE);
            },
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: FlatButton(
                padding: EdgeInsets.only(
                    left: adapt(79),
                    right: adapt(79),
                    top: adapt(13),
                    bottom: adapt(13)),
                child: Text(
                  "退出当前帐号",
                  style: TextStyle(color: Colors.white, fontSize: sp(16)),
                ),
                color: Color(0xFFCFCFCF),
                onPressed: _popupQuitDialog,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(adapt(22))),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: adapt(52)))
        ],
      ),
    );
  }

  Future<void> _popupQuitDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('提示'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    '是否退出登录？',
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    AccountManager.getInstance().logOut();
                    AppController.navigateTo(context, AppRoutes.ROUTE_MAIN, clearStack: true);
                  },
                  child: Text('确定')),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('取消')),
            ],
          );
        });
  }
}
