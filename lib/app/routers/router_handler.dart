import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:seekyouapp/app/routers/404.dart';

var widgetNotFoundHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new WidgetNotFound();
});
