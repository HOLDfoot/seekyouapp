
import 'package:flutter/widgets.dart';
import 'package:seekyouapp/ui/base/base_stateless_widget.dart';
import 'package:seekyouapp/util_set.dart';

/// 通用的网络失败空界面
class EmptyBodyWidget extends BaseStatelessPage {
  EmptyBodyWidget();


  Widget build(BuildContext context) {
    return Center(
      child:  Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/images/ic_empty_body.png",
            width: adapt(282),
            height: adapt(153),
            fit: BoxFit.contain,
          ),
          Container(
            margin: EdgeInsets.only(top: adapt(3), bottom: adapt(105)),
            child: Text(
              "网络加载失败了鸭~",
              style: TextStyle(color: Color(0xFF999999), fontSize: sp(12)),
            ),
          )
        ],
      ),
    );
  }
}
