import 'package:flutter/material.dart';
//import 'package:oktoast/oktoast.dart' as toast;
import 'package:seekyouapp/util_set.dart';
import 'package:oktoast/oktoast.dart' as toast;

/// see doc: https://pub.flutter-io.cn/packages/oktoast
class Fluttertoast {
  static double _radiusRadius = 30;
  static double _marginBottom = 100;

  static showToast({String msg = ""}) {
    if (msg == null || msg == "") return;
    toast.showToast(msg,
        position: toast.ToastPosition.bottom,
        radius: adapt(30),
        textPadding: EdgeInsets.only(
            left: adapt(10),
            right: adapt(10),
            top: adapt(5),
            bottom: adapt(5)));
    //showToastWidget();
  }

  static showToastWidget({String msg = ""}) {
    msg = "Hello world!";
    if (msg == null || msg == "") return;
    toast.ToastFuture toastFuture = toast.showToastWidget(
        new Align(
            alignment: Alignment.bottomCenter,
            //color: Colors.green,
            child: Container(
                margin: EdgeInsets.only(bottom: adapt(_marginBottom)),
                padding: EdgeInsets.only(
                    left: adapt(10),
                    right: adapt(10),
                    top: adapt(5),
                    bottom: adapt(5)),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                        Radius.circular(adapt(_radiusRadius)))),
                child: Text(
                  msg,
                  style: TextStyle(color: Colors.white),
                ))),
        duration: Duration(milliseconds: 1500));
/*    Future.delayed(Duration(milliseconds: 1000), () {
      toastFuture.dismiss(); // dismiss
    });*/
  }
}
