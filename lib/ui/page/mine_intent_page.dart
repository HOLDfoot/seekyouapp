
import 'package:flutter/material.dart';
import 'package:seekyouapp/net/api/app_api.dart';
import 'package:seekyouapp/ui/base/base_state_widget.dart';
import 'package:seekyouapp/ui/widget/method_util.dart';
import 'package:seekyouapp/util/toast_util.dart';
import 'package:seekyouapp/util_set.dart';

class MineIntentPage extends BaseStatefulPage {
  final Map<String, List<String>> pageParam;

  MineIntentPage({this.pageParam});

  @override
  BaseState createState() => new MineIntentPageState();
}

class MineIntentPageState extends BaseState<MineIntentPage> {
  final TextEditingController _mineIntentController =
  new TextEditingController(text: "");

  int _characterLength = 0;
  static const maxWords = 500;

  void textChangeListener() {
    setState(() {
      if (_mineIntentController.text != null) {
        _characterLength = _mineIntentController.text.length;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getMineUserIntent();
    _mineIntentController.addListener(textChangeListener);
  }

  @override
  void dispose() {
    super.dispose();
    _mineIntentController.removeListener(textChangeListener);
  }


  /// 从服务器请求当前用户的userIntent信息
  void getMineUserIntent() async {
    ResultData resultData = await AppApi.getInstance().getUserIntent(context, true);
    if (resultData.isSuccess()) {
      setState(() {
        _mineIntentController.text = resultData.data["userIntent"];
      });
    }
  }

  /// 把编辑结果发送到服务器
  void _complete() async {
    FocusScope.of(context).requestFocus(FocusNode());
    Map<String, String> param = {"userIntent" :  _mineIntentController.text};
    ResultData resultData = await AppApi.getInstance().updateMineIntent(context, true, param);
    if (resultData.isSuccess()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _scaffold();
  }

  _scaffold() {
    return new Scaffold(
        backgroundColor: Color(0xFFF3F5F9),
        appBar: backActionAppbar(context, "我和我的意向", _action(), backFunc: () {
          _complete();
        }),
        body: WillPopScope(
            child: Container(
              child: Container(
                margin: EdgeInsets.only(top: adapt(1)),
                height: adapt(500),
                color: Colors.white,
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: adapt(15), right: adapt(15), bottom: adapt(10)),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        maxLength: maxWords,
                        maxLines: 100,
                        style:
                        TextStyle(color: Color(0xff222222), fontSize: 15),
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: "简单的介绍一下自己和自己的意向吧～",
                            hintStyle: TextStyle(color: Color(0xFF999999))),
                        controller: _mineIntentController,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onWillPop: () {
              return Future.value(true);
            }));
  }

  _action() {
    return Container(
      width: adapt(50),
      height: adapt(25),
      margin: EdgeInsets.only(right: 10),
      child: RaisedButton(
        child: Text(
          "完成",
          style: TextStyle(fontSize: 14, color: Color(0xFF222222)),
        ),
        disabledColor: Color(0xffeeeeee),
        disabledTextColor: Color(0xff999999),
        padding: EdgeInsets.all(0),

        /// 默认padding影响宽度
        color: Color(0xFFFFD511),
        onPressed: _characterLength < 1
            ? null
            : () {
          _complete();
        },
        shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(adapt(5))),
      ),
    );
  }
}
