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
        body: PageView.builder(
            scrollDirection: Axis.vertical,
            controller: pageController,
            onPageChanged: onPageChange,
            itemCount: userList.length,
            itemBuilder: getPageViewItemWidget));
  }

  Widget getPageViewItemWidget(BuildContext context, int index) {
    return PageViewItem(
      user: userList[index],
    );
  }

  void onPageChange(int nextPage) {
    curPageIndex = nextPage;
  }
}

class PageViewItem extends BaseStatefulPage {
  User user;

  PageViewItem({Key key, this.user}) : super(key: key);

  @override
  PageViewItemState createState() {
    return PageViewItemState(user: user);
  }
}

class PageViewItemState extends BaseState<PageViewItem> {
  User user;

  PageViewItemState({this.user});

  PageController pageController;
  int curPageIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        makePhotoWidget(),
        PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: pageController,
            onPageChanged: onPageChange,
            itemCount: 3,
            itemBuilder: getPageViewItemWidget)
      ],
    ));
  }

  Widget makePhotoWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: CachedNetworkImage(
        imageUrl: user.userPhoto,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }

  Widget getPageViewItemWidget(BuildContext context, int index) {
    if (index == 0) {
      // 用户的个人信息和❤️按钮
      return Container(
        width: double.infinity,
        height: double.infinity,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 120,
            width: double.infinity,
            color: Colors.yellow,
          ),
        ),
      );
    } else if (index == 1) {
      return Container(); // 一个空界面
    } else {
      // 当前用户的征婚交友声明, 文字可以无限滚动
      return Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.all(adapt(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("你: "),
                    ),
                    Container(
                      child: Text("我: "),
                    ),
                  ],
                ),
              ),
            ],
          ));
    }
  }

  void onPageChange(int nextPage) {
    curPageIndex = nextPage;
  }
}
