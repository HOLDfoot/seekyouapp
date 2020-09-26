import 'package:flutter/material.dart';
import 'package:seekyouapp/ui/base/base_stateless_widget.dart';
import 'package:seekyouapp/util_set.dart';

/// 圆形进度样式
class ProgressWidget extends BaseStatelessPage {
  final double circleDiameter;
  final Color circleColor;

  ProgressWidget({double circleDiameter, Color circleColor})
      : this.circleDiameter = circleDiameter ?? adapt(60),
        this.circleColor = circleColor ?? const Color(0xFF6278FF);

  @override
  Widget build(BuildContext context) {
    return new Material(
      color: Colors.transparent,
      child: new SizedBox(
        width: circleDiameter,
        height: circleDiameter,
        child: new CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(circleColor),
        ),
      ),
    );
  }
}
