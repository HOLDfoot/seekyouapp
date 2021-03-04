import 'package:flutter/material.dart';
import 'package:seekyouapp/ui/base/base_state_widget.dart';
import 'package:seekyouapp/ui/widget/method_util.dart';
import 'package:seekyouapp/util_set.dart';

class LongTextPage extends BaseStatefulPage {
  //final Map<String, List<String>> pageParam;

  LongTextPage({Map<String, List<String>> pageParam}) : super(pageParam: pageParam);

  @override
  BaseState createState() => new LongTextPageState();
}

class LongTextPageState extends BaseState<LongTextPage> {
  final TextEditingController longTextController =
  new TextEditingController(text: "");

  int _characterLength = 0;
  int minWords = 5;
  int maxWords = 500;
  String pageTitle = "文本输入器";
  String pageContentHint = "输入文本";

  void textChangeListener() {
    setState(() {
      if (longTextController.text != null) {
        _characterLength = longTextController.text.length;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    pageTitle = getPageParamWithKey("title", defaultValue: pageTitle);
    pageContentHint = widget.pageParam["hint"][0]??pageContentHint;
    minWords = int.tryParse(getPageParamWithKey("minLength", defaultValue: minWords).toString());
    maxWords = int.parse(getPageParamWithKey("maxLength", defaultValue: maxWords).toString());
    longTextController.addListener(textChangeListener);
  }

  @override
  void dispose() {
    super.dispose();
    longTextController.removeListener(textChangeListener);
  }

  /// 把编辑结果返回
  void _complete() async {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.of(context).pop(longTextController.text);
  }

  @override
  Widget build(BuildContext context) {
    return _scaffold();
  }

  _scaffold() {
    return new Scaffold(
        backgroundColor: Color(0xFFF3F5F9),
        appBar: backActionAppbar(context, pageTitle, _action(), backFunc: () {
          Navigator.of(context).pop();
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
                            hintText: pageContentHint,
                            hintStyle: TextStyle(color: Color(0xFF999999))),
                        controller: longTextController,
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
        onPressed: _characterLength < minWords
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
