import 'package:flutter/material.dart';
import 'package:seekyouapp/ui/widget/dialog_common.dart';
import 'package:seekyouapp/util_set.dart';


class WidgetUtil {
  static Container getColorPoint(double radius, Color color) {
    return Container(
      width: adapt(radius * 2),
      height: adapt(radius * 2),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(radius))),
    );
  }

  /// 获取页面内默认进度条
  static Widget getProgressWidget({double diameter, Color color}) {
    return Center(
      child: ProgressWidget(circleDiameter: diameter, circleColor: color,),
    );
  }
}
