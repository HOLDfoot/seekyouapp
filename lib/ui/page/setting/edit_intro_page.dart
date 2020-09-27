
import 'package:flutter/material.dart';
import 'package:seekyouapp/ui/base/base_state_widget.dart';
import 'package:seekyouapp/ui/widget/method_util.dart';
import 'package:seekyouapp/util/toast_util.dart';
import 'package:seekyouapp/util_set.dart';

class EditIntroPage extends BaseStatefulPage {
  final Map<String, List<String>> pageParam;

  EditIntroPage({this.pageParam});

  @override
  BaseState createState() => new EditIntroPageState();
}

class EditIntroPageState extends BaseState<EditIntroPage> {
  final TextEditingController _moodController =
      new TextEditingController(text: "");

  String _desc;
  int _characterLength = 0;

  void _moodListener() {
    logger.d("_moodListener");
    if (_moodController.text != null && _moodController.text.length > 20) {
      Fluttertoast.showToast(msg: "保留点神秘感，最多20个字哦");
      _moodController.text = _desc;
      return;
    }
    _desc = _moodController.text;
    setState(() {
      if (_desc != null) {
        setState(() {
          _characterLength = _desc.length;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _desc = widget.pageParam["userDesc"][0];

    _moodController.text = _desc;
    _moodController.addListener(_moodListener);
  }

  @override
  void dispose() {
    super.dispose();
    _moodController.removeListener(_moodListener);
  }

  _complete(String desc) {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.pop(context, desc);
  }

  @override
  Widget build(BuildContext context) {
    return _scaffold();
  }

  _scaffold() {
    return new Scaffold(
        backgroundColor: Color(0xFFF3F5F9),
        appBar: backActionAppbar(context, "简介", _action(), backFunc: () {
          _complete(_desc);
        }),
        body: WillPopScope(
            child: Container(
              child: Container(
                margin: EdgeInsets.only(top: adapt(1)),
                height: adapt(179),
                color: Colors.white,
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: adapt(15), right: adapt(15), bottom: adapt(10)),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        maxLength: 20,
                        maxLines: 7,
                        style:
                            TextStyle(color: Color(0xff222222), fontSize: 15),
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: "简单的介绍一下自己吧～",
                            hintStyle: TextStyle(color: Color(0xFF999999))),
                        controller: _moodController,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onWillPop: () {
              _complete(_desc);
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
                _complete(_desc);
              },
        shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(adapt(5))),
      ),
    );
  }
}
