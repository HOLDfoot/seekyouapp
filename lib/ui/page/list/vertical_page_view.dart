import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seekyouapp/app/routers/navigate.dart';
import 'package:seekyouapp/app/routers/routers.dart';
import 'package:seekyouapp/data/manager/user.dart';
import 'package:seekyouapp/data/manager/user_manager.dart';
import 'package:seekyouapp/net/api/app_api.dart';
import 'package:seekyouapp/net/model/user_preference_model.dart';
import 'package:seekyouapp/platform/wrapper/system_service.dart';
import 'package:seekyouapp/ui/base/base_state_widget.dart';
import 'package:seekyouapp/ui/constant/product_constant.dart';
import 'package:seekyouapp/ui/widget/method_util.dart';
import 'package:seekyouapp/util/StringUtils.dart';
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
    initTags();
    requestUserPreference();
  }

  /// 请求用户详细信息
  void requestUserPreference() async {
    // 当前用户是否喜欢它
    // 明确的个人信息
    ResultData resultData = await AppApi.getInstance().getUserPreference(context, theUserId: user.userId);

    if (resultData.isSuccess()) {
      UserPreferenceModel userPreferenceModel = UserPreferenceModel.fromJson(resultData.data);
      setState(() {
          user.userIntent = userPreferenceModel.userIntent;
          user.likeTheUser = userPreferenceModel.likeTheUser;
      });
    }
  }

  /// 双击事件, 通知服务器, 喜欢当前的用户, 并且让like图标显示
  void onDoubleTap() async {
    if (!user.likeTheUser) {
      updateLikeUser(true);
    }
  }

  void updateLikeUser(bool likeUser) async {
    ResultData resultData = await AppApi.getInstance().updateLikeUser(
        context, true,
        likeUser: likeUser, theUserId: user.userId);
    // 成功发送到服务器
    if (resultData.isSuccess()) {
      setState(() {
        user.likeTheUser = likeUser;
      });
    }
  }

  /// 长按事件, 显示举报/不喜欢对话框
  void onLongPress() async {
    await showMoreOptions();
  }

  Future showMoreOptions() async {
    List<Widget> children = [
      SimpleDialogOption(
        child: Center(child: Text(user.likeTheUser ? "取消喜欢" : "喜欢这个人")),
        onPressed: () {
          Navigator.of(context).pop(Option.updateLikeUser);
        },
      ),
      SimpleDialogOption(
        child: Center(child: Text('不喜欢, 不想再看到')),
        onPressed: () {
          Navigator.of(context).pop(Option.hateUser);
        },
      ),
      SimpleDialogOption(
        child: Center(child: Text('举报当前用户违规')),
        onPressed: () async {
          Map<String, dynamic> param = {
            "title": "举报信息",
            "hint": "填写举报信息",
            "minLength": 10,
            "maxLength": 100,
          };
          Navigator.of(context).pop(Option.reportUser);
          await AppController.withParam(context, AppRoutes.ROUTE_LONG_TEXT,
                  params: param)
              .then((value) async {
            if (value != null) {
              ResultData resultData = await AppApi.getInstance().reportUser(
                  context, true,
                  theUserId: user.userId, reportText: value);
              if (resultData.isSuccess()) {
                Fluttertoast.showToast(msg: "举报成功");
              }
            }
          });
        },
      ),
    ];

    final option = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Center(child: Text('更多选择')), children: children);
        });

    switch (option) {
      case Option.updateLikeUser:
        updateLikeUser(!user.likeTheUser);
        break;
      case Option.hateUser:
        ResultData resultData = await AppApi.getInstance()
            .hateUser(context, false, theUserId: user.userId);
        // 成功发送到服务器
        if (resultData.isSuccess()) {
          Fluttertoast.showToast(msg: "你以后不会再看到它了~");
        }
        break;
      case Option.reportUser:
        // 在新的界面填写举报信息

        break;
      default:
    }
  }

  void initTags() {
    tags = [];
    if (!TextUtil.isEmpty(user.userGender)) {
      tags.add(user.userGender == "m" ? "男" : "女");
    }
    if (user.userAge != 0) {
      tags.add(user.userAge.toString());
    }
    if (!TextUtil.isEmpty(user.userArea)) {
      tags.add(user.userArea);
    }
    if (!TextUtil.isEmpty(user.userHobbies)) {
      tags.addAll(user.userHobbies.split(","));
    }
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

  List<String> tags = [];

  Widget getPageViewItemWidget(BuildContext context, int index) {
    if (index == 0) {
      // 用户的个人信息和❤️按钮
      return GestureDetector(
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white.withAlpha(2),
          child: Stack(children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white.withOpacity(0.6),
                width: double.infinity,
                padding: EdgeInsets.all(10),
                //alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  verticalDirection: VerticalDirection.up,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.userDesc ?? "",
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 5,
                      runSpacing: 5,
                      runAlignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      verticalDirection: VerticalDirection.down,
                      clipBehavior: Clip.hardEdge,
                      children: <Widget>[
                        for (String item in tags) TagItem(item)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Offstage(
                offstage: !user.likeTheUser,
                child: GestureDetector(
                  onTap: () {
                    updateLikeUser(false);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 240, right: 10),
                    child: Image.asset(
                      'assets/images/icon_favourite_checked.png',
                      width: adapt(50),
                      height: adapt(50),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ])
        ),
      );
    } else if (index == 2) {
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
              SafeArea(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: EdgeInsets.all(adapt(15)),
                  child: user.userIntent == null
                      ? Center(
                          child: Text("当前用户还没有填写个人意向"),
                        )
                      : SingleChildScrollView(
                          child: Text(
                            user.userIntent ?? "",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                            //overflow: TextOverflow.clip,
                          ),
                        ),
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

class TagItem extends StatelessWidget {
  String text;

  TagItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(3))),
      child: Container(
        padding: EdgeInsets.all(3),
        child: Text(text),
      ),
    );
  }
}

enum Option { updateLikeUser, hateUser, reportUser }
