import 'dart:convert';

import 'package:city_pickers/city_pickers.dart';
import 'package:city_pickers/modal/result.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seekyouapp/app/provider/UserProvider.dart';
import 'package:seekyouapp/app/routers/navigate.dart';
import 'package:seekyouapp/app/routers/routers.dart';
import 'package:seekyouapp/data/constant/app_color.dart';
import 'package:seekyouapp/data/manager/user.dart';
import 'package:seekyouapp/data/manager/user_manager.dart';
import 'package:seekyouapp/net/api/app_api.dart';
import 'package:seekyouapp/ui/base/base_state_widget.dart';
import 'package:seekyouapp/ui/dialog/dialog_choose_gender.dart';
import 'package:seekyouapp/ui/widget/method_util.dart';
import 'package:seekyouapp/util/StringUtils.dart';
import 'package:seekyouapp/util/log.dart';
import 'package:seekyouapp/util/regExp_util.dart';
import 'package:seekyouapp/util/toast_util.dart';
import 'package:seekyouapp/util_set.dart';

class EditMinePage extends BaseStatefulPage {
  EditMinePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EditMinePageState createState() => _EditMinePageState();
}

class _EditMinePageState extends BaseState<EditMinePage> {
  final TextEditingController _nameController =
      new TextEditingController(text: "");
  final TextEditingController _contactController =
      new TextEditingController(text: "");
  final TextEditingController _ageController =
      new TextEditingController(text: "");
  final TextEditingController _genderController =
      new TextEditingController(text: "");
  final TextEditingController _locationController =
      new TextEditingController(text: "");
  final TextEditingController _descController =
      new TextEditingController(text: "");
  final TextEditingController _hobbyController =
      new TextEditingController(text: "");

  User _user;

  @override
  void initState() {
    super.initState();
    _user = AccountManager.getInstance().getUser();
    if (_user == null) {
      popThis();
      return;
    }
    _nameController.text = _user.userName;
    _ageController.text = _user.userAge != null ? _user.userAge.toString() : "";
    _genderController.text = ObjectUtil.isEmpty(_user.userGender)
        ? ""
        : _user.userGender == "f" ? "女" : "男";
    _descController.text = _user.userDesc;
    _contactController.text = TextUtil.isEmpty(_user.userWx) ? _user.userQq : _user.userWx;
    _hobbyController.text = _user.userHobbies?.replaceAll(",", " ");
    _locationController.text = _user.userArea??"";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: QuColor.backgroundColor,
      appBar: backActionAppbar(context, "个人信息", _action()),
      body: _body(),
    );
  }

  _action() {
    return Container(
      width: adapt(50),
      height: adapt(25),
      margin: EdgeInsets.only(right: 10),
      child: RaisedButton(
        child: Text(
          "保存",
          style: TextStyle(fontSize: 14, color: Color(0xFF222222)),
        ),
        disabledColor: Color(0xffeeeeee),
        disabledTextColor: Color(0xff999999),
        padding: EdgeInsets.all(0),

        /// 默认padding影响宽度
        color: Color(0xFFFFD511),
        onPressed: () {
          _clickSaveEdit();
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(adapt(5))),
      ),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            child: Container(
                color: Colors.white,
                height: adapt(78),
                margin: EdgeInsets.only(top: adapt(1), bottom: adapt(10)),
                padding: EdgeInsets.only(left: adapt(15), top: adapt(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "昵称",
                        style: TextStyle(
                            fontSize: sp(15), color: Color(0xFF222222)),
                      ),
                    ),
                    SizedBox(height: adapt(3)),
                    Expanded(
                      child: Container(
                        child: TextField(
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontSize: sp(15), color: Color(0xFF222222)),
                          maxLines: 2,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  color: Color(0xFFCECECE), fontSize: sp(15)),
                              hintText: "只能是汉字、字母、数字组成"),
                          controller: _nameController,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          InkWell(
            child: Container(
                color: Colors.white,
                height: adapt(78),
                margin: EdgeInsets.only(bottom: adapt(10)),
                padding: EdgeInsets.only(left: adapt(15), top: adapt(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "年龄",
                        style: TextStyle(
                            fontSize: sp(15), color: Color(0xFF222222)),
                      ),
                    ),
                    SizedBox(height: adapt(3)),
                    Expanded(
                      child: Container(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontSize: sp(15), color: Color(0xFF222222)),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  color: Color(0xFFCECECE), fontSize: sp(15)),
                              hintText: "请输入你的年龄"),
                          controller: _ageController,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          InkWell(
            child: Container(
                color: Colors.white,
                height: adapt(78),
                margin: EdgeInsets.only(bottom: adapt(10)),
                padding: EdgeInsets.only(left: adapt(15), top: adapt(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "性别",
                        style: TextStyle(
                            fontSize: sp(15), color: Color(0xFF222222)),
                      ),
                    ),
                    SizedBox(height: adapt(3)),
                    Expanded(
                      child: Container(
                        child: TextField(
                          enableInteractiveSelection: false,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontSize: sp(15), color: Color(0xFF222222)),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  color: Color(0xFFCECECE), fontSize: sp(15)),
                              hintText: "请选择你的性别"),
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            _clickGenderSelect();
                          },
                          controller: _genderController,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                )),
            onTap: () {
              _clickGenderSelect();
            },
          ),
          InkWell(
            child: Container(
                color: Colors.white,
                height: adapt(78),
                margin: EdgeInsets.only(top: adapt(1), bottom: adapt(10)),
                padding: EdgeInsets.only(left: adapt(15), top: adapt(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "联系方式",
                        style: TextStyle(
                            fontSize: sp(15), color: Color(0xFF222222)),
                      ),
                    ),
                    SizedBox(height: adapt(3)),
                    Expanded(
                      child: Container(
                        child: TextField(
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontSize: sp(15), color: Color(0xFF222222)),
                          maxLines: 2,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  color: Color(0xFFCECECE), fontSize: sp(15)),
                              hintText: "微信号或QQ号"),
                          controller: _contactController,
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          InkWell(
            child: Container(
                color: Colors.white,
                height: adapt(78),
                margin: EdgeInsets.only(bottom: adapt(10)),
                padding: EdgeInsets.only(left: adapt(15), top: adapt(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "所在位置",
                        style: TextStyle(
                            fontSize: sp(15), color: Color(0xFF222222)),
                      ),
                    ),
                    SizedBox(height: adapt(3)),
                    Expanded(
                      child: Container(
                        child: TextField(
                          enableInteractiveSelection: false,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontSize: sp(15), color: Color(0xFF222222)),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  color: Color(0xFFCECECE), fontSize: sp(15)),
                              hintText: "更新位置信息可以更准确的描述自己～"),
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            _clickLocationSelect();
                          },
                          controller: _locationController,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                )),
            onTap: () {
              _clickLocationSelect();
            },
          ),
          InkWell(
            child: Container(
                color: Colors.white,
                height: adapt(78),
                margin: EdgeInsets.only(bottom: adapt(10)),
                padding: EdgeInsets.only(left: adapt(15), top: adapt(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "简介",
                        style: TextStyle(
                            fontSize: sp(15), color: Color(0xFF222222)),
                      ),
                    ),
                    SizedBox(height: adapt(3)),
                    Expanded(
                      child: Container(
                        child: TextField(
                          enableInteractiveSelection: false,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontSize: sp(15), color: Color(0xFF222222)),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  color: Color(0xFFCECECE), fontSize: sp(15)),
                              hintText: "简单的介绍一下自己吧～"),
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            _clickProfileSelect();
                          },
                          controller: _descController,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                )),
            onTap: () {
              _clickProfileSelect();
            },
          ),
          InkWell(
            child: Container(
                color: Colors.white,
                height: adapt(78),
                margin: EdgeInsets.only(bottom: adapt(10)),
                padding: EdgeInsets.only(left: adapt(15), top: adapt(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "爱好",
                        style: TextStyle(
                            fontSize: sp(15), color: Color(0xFF222222)),
                      ),
                    ),
                    SizedBox(height: adapt(3)),
                    Expanded(
                      child: Container(
                        child: TextField(
                          enableInteractiveSelection: false,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontSize: sp(15), color: Color(0xFF222222)),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  color: Color(0xFFCECECE), fontSize: sp(15)),
                              hintText: "找到和你相似的人"),
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            _clickHobbySelect();
                          },
                          controller: _hobbyController,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                )),
            onTap: () {
              _clickHobbySelect();
            },
          ),
        ],
      ),
    );
  }

  /// 性别
  _clickGenderSelect() {
    logger.d("_clickGenderSelect _currentGender");
    ChooseGenderDialog chooseGenderDialog =
        ChooseGenderDialog(_genderController.text, (select, text) {
      logger.d("_clickGenderSelect select= " + select + " text= " + text);
      setState(() {
        _genderController.text = text;
      });
    });
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return chooseGenderDialog;
        });
  }

  /// 位置信息
  _clickLocationSelect() async {
    Result cityResult = await CityPickers.showCityPicker(context: context);
    print("cityResult: ${cityResult.toString()}");
    if (cityResult != null) {
      setState(() {
        _locationController.text = cityResult.cityName + ":" + cityResult.areaName;
      });
    }
  }

  /// 简介
  _clickProfileSelect() {
    String uriEncode = Uri.encodeComponent(_descController.text ?? "");
    // AppController.navigateTo(
    //         context, AppRoutes.ROUTE_SETTING_MINE_DESC + "?userDesc=$uriEncode");
    AppController.withParam(
            context, AppRoutes.ROUTE_SETTING_MINE_DESC, params: {"userDesc" : _descController.text})
        .then((value) {
      setState(() {
        _descController.text = value;
      });
    });
  }

  /// 爱好
  _clickHobbySelect() {
    String uriEncode = Uri.encodeComponent(_hobbyController.text ?? "");
    AppController.navigateTo(context,
            AppRoutes.ROUTE_SETTING_MINE_HOBBIES + "?userHobbies=$uriEncode")
        .then((value) {
      String userHobbies = value.trim();
      if (!TextUtil.isEmpty(userHobbies)) {
        List hobbies = userHobbies.split(" ");
        // 移除多个空格split的情况
        hobbies.removeWhere((element) {
          return TextUtil.isEmpty(element);
        });
        userHobbies = StringUtils.join(hobbies, " ");
      }
      setState(() {
        _hobbyController.text = userHobbies;
      });
    });
  }

  /// 保存
  _clickSaveEdit() async {
    User updateUser = new User();
    updateUser.userName = _nameController.text;
    if (!CharUtil.isOnlyChar(updateUser.userName)) {
      Fluttertoast.showToast(msg: "名字只能是字母或数字");
      return;
    }
    updateUser.userAge = int.parse(_ageController.text);
    if (updateUser.userAge > 99 || updateUser.userAge < 16) {
      Fluttertoast.showToast(msg: "年龄[16,99]");
      return;
    }
    updateUser.userGender = _genderController.text == "男" ? "m" : _genderController.text == "女" ? "f" : null;
    String contact = _contactController.text;
    if (RegexUtil.isQQ(contact)) {
      updateUser.userQq = contact;
    } else {
      updateUser.userWx = contact;
    }
    updateUser.userDesc = _descController.text;
    String hobbyText = _hobbyController.text;
    if (hobbyText != null) {
      updateUser.userHobbies = hobbyText.replaceAll(" ", ",");
    } else {
      updateUser.userHobbies = "";
    }
    updateUser.userArea = _locationController.text;

    Map<String, dynamic> param = updateUser.toJson();
    ResultData resultData = await AppApi.getInstance().updateUser(context, true, param);
    if (resultData.isSuccess()) {
      User user = User.fromJson(resultData.data);
      AccountManager.getInstance().cacheUser(user);
      //context.read<UserProvider>().updateUser(_user);
      AccountManager.getInstance().notifyUserOnUi(context);

      popThis();
    } else {
      resultData.toast();
    }
  }
}
