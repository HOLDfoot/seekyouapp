import 'package:flutter/material.dart';
import 'package:seekyouapp/data/constant/app_color.dart';
import 'package:seekyouapp/util_set.dart';

backAppbar(BuildContext context, String title,
    {bool withDivider = false, Function tapTitleFunc}) {
  Widget preferredWidget;
  AppBar appBar = AppBar(
    elevation: 0,
    backgroundColor: Theme.of(context).cardColor,
//    backgroundColor: QuColor.titleBgColor,
    leading: _leading(context),
    title: InkWell(
      child: Text(
        title,
        style: TextStyle(fontSize: 18, color: Color(0xFF000000)),
      ),
      onTap: tapTitleFunc,
    ),
    centerTitle: true,
  );
  if (withDivider == true) {
    preferredWidget = DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(width: adapt(1), color: QuColor.barDivideColor))),
      child: appBar,
    );
  } else {
    preferredWidget = appBar;
  }
  return PreferredSize(
      preferredSize: Size.fromHeight(adapt(48)), child: preferredWidget);
}

backActionAppbar(BuildContext context, String title, Widget action,
    {bool withDivider = false, Function tapTitleFunc, Function backFunc}) {
  Widget preferredWidget;
  AppBar appBar = AppBar(
    elevation: 0,
    backgroundColor: Theme.of(context).cardColor,
    leading: _leading(context, backFunc: backFunc),
    title: InkWell(
      child: Text(
        title,
        style: TextStyle(fontSize: 18, color: Color(0xFF000000)),
      ),
      onTap: tapTitleFunc,
    ),
    centerTitle: true,
    actions: <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          action,
        ],
      ),
    ],
  );
  if (withDivider == true) {
    preferredWidget = DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(width: adapt(1), color: QuColor.barDivideColor))),
      child: appBar,
    );
  } else {
    preferredWidget = appBar;
  }
  return PreferredSize(
      preferredSize: Size.fromHeight(adapt(48)), child: preferredWidget);
}

baseAppbar(BuildContext context, String title, Widget leading, Widget action) {
  return PreferredSize(
      preferredSize: Size.fromHeight(adapt(48)),
      child: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).cardColor,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[leading],
        ),
        title: InkWell(
          child: Text(
            title,
            style: TextStyle(fontSize: 18, color: Color(0xFF000000)),
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              action,
            ],
          ),
        ],
      ));
}

_leading(BuildContext context, {Function backFunc}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        width: adapt(41),
        padding: EdgeInsets.all(0),
        child: new IconButton(
          padding: EdgeInsets.only(left: adapt(10), right: adapt(20)),
          icon: Image.asset(
            'assets/images/ic_black_left_arrow.png',
            fit: BoxFit.contain,
            width: adapt(11),
            height: adapt(18),
          ),
          onPressed: () {
            if (backFunc == null) {
              _popThis(context);
            } else {
              backFunc();
            }
          },
        ),
      ),
    ],
  );
}

void _popThis(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
}