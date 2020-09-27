
import 'package:flutter/material.dart';
import 'package:seekyouapp/ui/base/base_state_widget.dart';
import 'package:seekyouapp/ui/widget/method_util.dart';
import 'package:seekyouapp/util/toast_util.dart';
import 'package:seekyouapp/util_set.dart';

class EditHobbyPage extends BaseStatefulPage {
  final Map<String, List<String>> pageParam;

  EditHobbyPage({this.pageParam});

  @override
  BaseState createState() => new EditHobbyPageState();
}

class EditHobbyPageState extends BaseState<EditHobbyPage> {
  final TextEditingController _moodController =
      new TextEditingController(text: "");

  String _desc;
  int _characterLength = 0;

  void _moodListener() {
    logger.d("_moodListener");
    if (_moodController.text != null && _moodController.text.length > 20) {
      Fluttertoast.showToast(msg: "最多20个字哦");
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
    _desc = widget.pageParam["userHobbies"][0];

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
        appBar: backActionAppbar(context, "爱好", _action(), backFunc: () {
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
                            hintText: "找到和你相似的人, 多个爱好可以用空格隔开～",
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
