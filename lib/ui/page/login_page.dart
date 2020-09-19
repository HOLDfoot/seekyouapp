import 'dart:convert';
import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:seekyouapp/data/manager/user.dart';
import 'package:seekyouapp/data/manager/user_manager.dart';
import 'package:seekyouapp/net/api/app_api.dart';
import 'package:seekyouapp/net/api/bean/weather_bean.dart';
import 'package:seekyouapp/util/toast_util.dart';
import 'package:seekyouapp/util_set.dart';
import 'package:flutter/cupertino.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool iSignUp = false;

  String email;
  String pass1;
  String pass2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Container(
            width: 280,
            child: Column(
              children: [
                Container(
                  height: 100,
                ),
                Container(
                  width: 280,
                  child: Center(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              iSignUp = false;
                            });
                          },
                          child: Container(
                            width: 140,
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              "登录",
                              style: TextStyle(
                                decoration: iSignUp
                                    ? TextDecoration.none
                                    : TextDecoration.underline,
                                fontSize: iSignUp ? 20 : 30,
                                color: Colors.yellow,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              iSignUp = true;
                            });
                          },
                          child: Container(
                            width: 140,
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              "注册",
                              style: TextStyle(
                                  decoration: iSignUp
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                  fontSize: iSignUp ? 30 : 20,
                                  color: Colors.yellow),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: adapt(50),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      /*Image.asset(
                        'assets/images/ic_smartphone.png',
                        width: adapt(32),
                        height: adapt(32),
                        fit: BoxFit.contain,
                      ),*/
                      Container(
                        width: 32,
                        height: 32,
                        child: Icon(
                          Icons.email,
                          size: 22,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: adapt(6))),
                      Expanded(
                        child: TextField(
                          autofocus: Platform.isAndroid,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (text) {
                            email = text;
                          },
                          style: TextStyle(
                              color: Color(0xff353535),
                              fontSize: sp(16),
                              textBaseline: TextBaseline.alphabetic),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "请输入邮箱",
                              hintStyle: TextStyle(
                                  fontSize: sp(16), color: Color(0xff999999))),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(bottom: adapt(10)),
                    height: adapt(1),
                    decoration: BoxDecoration(color: Color(0xffdfdfdf))),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    Container(
                      height: adapt(50),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/ic_padlock.png',
                            width: adapt(32),
                            height: adapt(32),
                            fit: BoxFit.contain,
                          ),
                          Padding(padding: EdgeInsets.only(right: adapt(10))),
                          Expanded(
                            child: TextField(
                              obscureText: true,
                              onChanged: (text) {
                                pass1 = text;
                              },
                              style: TextStyle(
                                  color: Color(0xff353535),
                                  fontSize: sp(16),
                                  textBaseline: TextBaseline.alphabetic),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "请输入密码",
                                  hintStyle: TextStyle(
                                      fontSize: sp(16),
                                      color: Color(0xff999999))),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                getPasswordAgain(),
                Container(
                  margin: EdgeInsets.only(top: 50),
                ),
                loginBtn()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getPasswordAgain() {
    if (!iSignUp) {
      return Container();
    }
    return Column(children: [
      Container(
          margin: EdgeInsets.only(bottom: adapt(10)),
          height: adapt(1),
          decoration: BoxDecoration(color: Color(0xffdfdfdf))),
      Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          Container(
            height: adapt(50),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/ic_padlock.png',
                  width: adapt(32),
                  height: adapt(32),
                  fit: BoxFit.contain,
                ),
                Padding(padding: EdgeInsets.only(right: adapt(10))),
                Expanded(
                  child: TextField(
                    obscureText: true,
                    onChanged: (text) {
                      pass2 = text;
                    },
                    style: TextStyle(
                        color: Color(0xff353535),
                        fontSize: sp(16),
                        textBaseline: TextBaseline.alphabetic),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "请再输入密码",
                        hintStyle: TextStyle(
                            fontSize: sp(16), color: Color(0xff999999))),
                  ),
                )
              ],
            ),
          ),
        ],
      )
    ]);
  }

  Widget loginBtn() {
    Color bgColor;
    Color textColor;
    bgColor = Color(0xFFFFD511);
    textColor = Color(0xFF353535);

    return Container(
      width: 150,
      height: 50,
      child: FlatButton(
        child: Text(
          "登录/注册",
          style: TextStyle(color: textColor, fontSize: sp(16)),
        ),
        disabledColor: bgColor,
        color: bgColor,
        onPressed: () {
          print("_verifyInput 111");

          if (_verifyInput()) {
            _doLogin();
          }
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(adapt(24))),
      ),
    );
  }

  bool _verifyInput() {
    print("_verifyInput");
    if (TextUtil.isEmpty(email)) {
      Fluttertoast.showToast(msg: "请输入邮箱");
      return false;
    }
    if (TextUtil.isEmpty(pass1)) {
      Fluttertoast.showToast(msg: "请输入密码");
      return false;
    }
    if (iSignUp && TextUtil.isEmpty(pass2)) {
      Fluttertoast.showToast(msg: "请再次输入邮箱");
      return false;
    }

    if (iSignUp && pass2 != pass1) {
      Fluttertoast.showToast(msg: "两次密码不一致");
      return false;
    }
    if (!email.contains("@")) {
      Fluttertoast.showToast(msg: "请输入合法邮箱");
      return false;
    }
    if (pass1.length < 6) {
      Fluttertoast.showToast(msg: "密码长度不小于6位");
      return false;
    }

    return true;
  }

  /// 将账号密码发送到服务器验证, 返回后进入下一个界面
  void _doLogin() async {
    Map<String, dynamic> param = {};
    param["email"] = email;
    param["password"] = pass1;
    ResultData resultData;
    if (iSignUp) {
      resultData =
      await AppApi.getInstance().signUp(context, true, param);
    } else {
      resultData =
      await AppApi.getInstance().signIn(context, true, param);
    }
    if (resultData.isSuccess()) {
      // 缓存用户信息, 然后结束本页面
      User user = User.fromJson(resultData.data);
      AccountManager.getInstance().logIn(user);
      Navigator.of(context).pop();
    } else {
      resultData.toast();
    }
  }

  _printWeather() async {
    ResultData resultData =
        await AppApi.getInstance().getWeather(context, true);
    if (resultData.isSuccess()) {
      WeatherBean weatherBean = WeatherBean.fromJson(resultData.response);
      Fluttertoast.showToast(msg: "成功获取本周天气, 显示周一天气");
      String weather = json.encode(weatherBean.result[1]);
      print("weather: $weather");
    }
  }
}
