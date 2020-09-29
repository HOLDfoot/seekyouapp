import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seekyouapp/data/manager/user.dart';
import 'package:seekyouapp/data/manager/user_manager.dart';
import 'package:seekyouapp/platform/wrapper/system_service.dart';
import 'package:seekyouapp/ui/base/base_state_widget.dart';
import 'package:seekyouapp/ui/constant/product_constant.dart';
import 'package:seekyouapp/ui/widget/method_util.dart';
import 'package:seekyouapp/util/toast_util.dart';
import 'package:seekyouapp/util_set.dart';

class VerticalViewPage extends BaseStatefulPage {
  final Map<String, List<String>> pageParam;

  VerticalViewPage({Key key, this.pageParam}) : super(key: key);

  @override
  VerticalViewPageState createState() {
    return VerticalViewPageState();
  }
}

class VerticalViewPageState extends BaseState<VerticalViewPage> {

  PageController pageController;
  int curPageIndex;
  List<User> userList;


  @override
  void initState() {
    super.initState();
    int index = int.parse(widget.pageParam["index"][0]);
    String userJson = widget.pageParam["userJson"][0];
    List list = json.decode(userJson);
    userList = [];
    list.forEach((e) {
      User user = User.fromJson(e);
      userList.add(user);
    });
    curPageIndex = index;
    pageController = PageController(initialPage: index);
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body: PageView(
          scrollDirection: Axis.vertical,
          controller: pageController,
          onPageChanged: onPageChange,
          children: getPageViewChildren()
        ));
  }

  List<Widget> getPageViewChildren() {
    List<Widget> children = [];
    userList.forEach((e) {
      Widget widget = CachedNetworkImage(
        imageUrl: e.userPhoto,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
      children.add(widget);
    });

    return children;
  }

  void onPageChange(int nextPage) {
    curPageIndex = nextPage;




  }

}
