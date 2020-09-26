import 'package:flutter/material.dart';
import 'package:seekyouapp/data/constant/app_color.dart';
import 'package:seekyouapp/ui/base/base_state_widget.dart';
import 'package:seekyouapp/util/logger.dart';
import 'package:seekyouapp/util_set.dart';

// ignore: must_be_immutable
typedef void SelectGender(String selectGender, String text); // 0:男, 1:女

class ChooseGenderDialog extends BaseStatefulPage {
  final currentGender;
  final SelectGender onSelect;

  ChooseGenderDialog(this.currentGender, this.onSelect);

  @override
  ChooseGenderDialogState createState() =>
      ChooseGenderDialogState(this.currentGender, this.onSelect);
}

class ChooseGenderDialogState extends BaseState<ChooseGenderDialog> {
  String _currentGender;
  final SelectGender onSelect;

  ChooseGenderDialogState(this._currentGender, this.onSelect);

  @override
  Widget build(BuildContext context) {
    return new Material(
      type: MaterialType.transparency,
      child: Listener(
        onPointerUp: (PointerUpEvent event) {
          Logger.log("onPointerUp");
          popThis();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: adapt(205),
              //height: adapt(128),
              decoration: ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: adapt(44),
                      child: Center(
                        child: Text(
                          "请选择你的性别",
                          style: TextStyle(
                              color: Color(0xFF222222), fontSize: sp(16)),
                        ),
                      )),
                  Container(
                    height: adapt(1),
                    color: QuColor.backgroundColor,
                  ),
                  //Padding(padding: EdgeInsets.only(bottom: adapt(14))),
                  // 放置第一个radio
                  Padding(padding: EdgeInsets.only(bottom: adapt(14))),
                  InkWell(
                    onTap: () {
                      onChange("m");
                    },
                    child: SizedBox(
                      height: adapt(21),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //color: Colors.yellowAccent,
                        children: <Widget>[
                          Radio<String>(
                              value: "m",
                              activeColor: Color(0xFFFFD511),
                              groupValue: this._currentGender,
                              onChanged: (String value) {
                                onChange(value);
                              }),
                          Text(
                            '男',
                            style: TextStyle(
                                color: Color(0xFF222222), fontSize: sp(14)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: adapt(14))),
                  InkWell(
                    onTap: () {
                      onChange("f");
                    },
                    child: SizedBox(
                        height: adapt(21),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          //color: Colors.yellowAccent,
                          children: <Widget>[
                            Radio<String>(
                                value: "f",
                                activeColor: Color(0xFFFFD511),
                                groupValue: this._currentGender,
                                onChanged: (String value) {
                                  onChange(value);
                                }),
                            Text(
                              '女',
                              style: TextStyle(
                                  color: Color(0xFF222222), fontSize: sp(14)),
                            ),
                          ],
                        )),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: adapt(14))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  onChange(v) {
    Logger.log("onChange v= " + v);
    String text;
    if (v == "m") {
      text = "男";
    } else {
      text = "女";
    }
    onSelect(v, text);
    setState(() {
      _currentGender = v;
    });
    popThis();
  }
}
