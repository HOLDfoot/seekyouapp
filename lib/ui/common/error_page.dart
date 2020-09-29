
import 'package:flutter/material.dart';

class SearchResultEmptyWidget extends StatelessWidget {
  final String title;

  SearchResultEmptyWidget({Key key, this.title = "没有数据"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(this.title);
  }
}