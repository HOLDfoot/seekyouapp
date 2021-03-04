import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seekyouapp/data/manager/user.dart';
import 'package:seekyouapp/data/manager/user_manager.dart';
import 'package:seekyouapp/net/api/app_api.dart';
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
    requestUserDetail();
  }

  /// 请求用户详细信息
  void requestUserDetail() async {
    // 当前用户是否喜欢它
    // 明确的个人信息
  }

  /// 双击事件, 通知服务器, 喜欢当前的用户, 并且让like图标显示
  void onDoubleTap() async {
    if (!likeTheUser) {
      updateLikeUser(true);
    }
  }

  void updateLikeUser(bool likeUser) async {
    ResultData resultData = await AppApi.getInstance().updateLikeUser(
        context, false,
        likeUser: likeTheUser, theUserId: user.userId);
    // 成功发送到服务器
    if (resultData.isSuccess()) {
      setState(() {
        likeTheUser = likeUser;
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
        child: Text(likeTheUser ? "取消喜欢" : "喜欢这个人"),
        onPressed: () {
          Navigator.of(context).pop(Option.updateLikeUser);
        },
      ),
      SimpleDialogOption(
        child: Text('不喜欢, 不想再看到'),
        onPressed: () {
          Navigator.of(context).pop(Option.hateUser);
        },
      ),
      SimpleDialogOption(
        child: Text('举报当前用户违规'),
        onPressed: () {
          Navigator.of(context).pop(Option.reportUser);
        },
      ),
    ];

    final option = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(title: Text('更多选择'), children: children);
        });

    switch (option) {
      case Option.updateLikeUser:
        updateLikeUser(!likeTheUser);
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
    if (TextUtil.isEmpty(user.userGender)) {
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

  bool likeTheUser = false;
  List<String> tags = [
    "男",
    "郑州",
    "28",
    "本科",
    "爱好看电视",
    "爱好看电视",
    "爱好看电视",
    "爱好看电视",
    "爱好看电视"
  ];

  Widget getPageViewItemWidget(BuildContext context, int index) {
    if (index == 0) {
      // 用户的个人信息和❤️按钮
      return GestureDetector(
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              //color: Colors.black26,
              padding: EdgeInsets.all(10),
              width: double.infinity,
              height: 300,
              child: Stack(children: [
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: 40,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "user.\nuserDesc??" "",
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                      ),
                      //child: Text(user.userDesc??""),
                    )),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 40),
                    child: Wrap(
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
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Offstage(
                    offstage: !likeTheUser,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 230),
                      child: Image.asset(
                        'assets/images/icon_favourite_checked.png',
                        width: adapt(50),
                        height: adapt(50),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
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
                      child: Text(
                          " 会员名：xxx性别：x年龄：xx岁（xx-xx-xx） 身高：xxx厘米 体重：xx公斤 学历：xx 职业：xx 收入：xxxx/元/月 征婚状态：征婚进行中 婚史：xx 所在地区：xx 征婚会员详细资料 民族：xx 血型：xx 星座：xx 属相：xx 外貌：xx 体型：xx 性格：xx 信仰：xx 单位：xx 结婚形式：xx住房：xx 是否有车：xx 职业类型：xx心目中的你： 年龄：x岁 - xx岁 身高：xxx厘米 - xxx厘米 学历：xx 收入：xxxx/元/月 婚史：xx 征婚范围：xx 最佳职业：xx电话：*** QQ：*** 手机：*** email：*** 邮局寄信地址： *** 邮政编码：*** 邮寄地址：*** 收信人 ：***。"),
                    ),
                    Container(
                      child: Text("我: "),
                    ),
                    Container(
                      child: Text(
                          " 会员名：xxx性别：x年龄：xx岁（xx-xx-xx） 身高：xxx厘米 体重：xx公斤 学历：xx 职业：xx 收入：xxxx/元/月 征婚状态：征婚进行中 婚史：xx 所在地区：xx 征婚会员详细资料 民族：xx 血型：xx 星座：xx 属相：xx 外貌：xx 体型：xx 性格：xx 信仰：xx 单位：xx 结婚形式：xx住房：xx 是否有车：xx 职业类型：xx心目中的你： 年龄：x岁 - xx岁 身高：xxx厘米 - xxx厘米 学历：xx 收入：xxxx/元/月 婚史：xx 征婚范围：xx 最佳职业：xx电话：*** QQ：*** 手机：*** email：*** 邮局寄信地址： *** 邮政编码：*** 邮寄地址：*** 收信人 ：***。"),
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
