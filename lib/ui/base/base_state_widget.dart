

import 'package:flutter/material.dart';
import 'package:seekyouapp/data/model/status_model.dart';
import 'package:seekyouapp/ui/widget/empty_body_widget.dart';
import 'package:seekyouapp/ui/widget/widget_util.dart';
import 'package:seekyouapp/util/logger.dart';

class BaseStatefulPage extends StatefulWidget {
  final Map<String, List<String>> pageParam;

  BaseStatefulPage({Key key, this.title, this.pageParam}) : super(key: key);

  BaseStatefulPage.param({this.pageParam}) : title = "";

  //BaseStatefulPage(this.title, {Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  BaseState createState() => BaseState();
}

class BaseState<T extends BaseStatefulPage> extends State<T> {
  FirstStatus _firstFrameStatus = new FirstStatus();
  bool isDispose = false;
  Logger logger;
  String _pageTAG;

  @override
  void initState() {
    _pageTAG = runtimeType.toString();
    logger = new Logger(_pageTAG);
    logger.d("initState");
    super.initState();

    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      if (_firstFrameStatus.isFirst()) {
        onFirstResume();
      }
      onEveryResume();
    });
  }

  @override
  void dispose() {
    isDispose = true;
    super.dispose();
  }

  /// 第一帧执行的方法
  void onFirstResume() {
    logger.d("onFirstResume");
  }

  /// 每一帧刷新都会执行
  void onEveryResume() {}

  bool isPop = false;

  void popThis() {
    logger.d("popThis isDispose= " + isDispose.toString());
    if (!isPop && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      isPop = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return BaseStatefulPage();
  }
  //int i = 0;

  /// 根据当前页面数据加载的状态更新界面3个状态: 显示loading, 显示内容, 显示空界面
  bool showEmptyWidget; // null: 显示loading, false: 显示内容, true: 显示空界面
  differBody(dynamic pageData, BodyCallback bodyCallback,
      {Widget progressWidget, Widget emptyWidget, bool showEmpty}) {
    showEmpty = showEmpty ?? showEmptyWidget;
    //logger.d("showEmpty is: " +  (showEmpty??"null").toString());
    if (pageData == null) {
      if (showEmpty == true) {
        emptyWidget = emptyWidget ?? EmptyBodyWidget();
        return emptyWidget;
      } else {
        progressWidget = progressWidget ?? WidgetUtil.getProgressWidget();
        return progressWidget;
      }
    } else {
      return bodyCallback();
    }
  }
}
typedef BodyCallback = Widget Function();

/// 如果需要StatefulWidget, 且不需要按照页面展示, 需要继承该类
class BaseStatefulWidget extends StatefulWidget {
  final Map<String, List<String>> pageParam;
  final String title;

  BaseStatefulWidget({Key key, this.title, this.pageParam}) : super(key: key);

  @override
  BaseWidgetState createState() => BaseWidgetState();
}

class BaseWidgetState<T extends BaseStatefulWidget> extends State<T> {
  Logger logger;

  @override
  void initState() {
    String _pageTAG = runtimeType.toString();
    logger = new Logger(_pageTAG);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }
}