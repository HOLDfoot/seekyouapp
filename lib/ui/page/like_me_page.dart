import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:seekyouapp/app/routers/navigate.dart';
import 'package:seekyouapp/app/routers/routers.dart';
import 'package:seekyouapp/data/manager/InitManager.dart';
import 'package:seekyouapp/data/manager/user.dart';
import 'package:seekyouapp/net/api/app_api.dart';
import 'package:seekyouapp/ui/common/error_page.dart';
import 'package:seekyouapp/ui/constant/dev_constant.dart';

/// 喜欢我的列表
class LikeMePage extends StatefulWidget {
  @override
  LikeMePageState createState() {
    return LikeMePageState();
  }
}

class LikeMePageState extends State<LikeMePage> {
  List<User> userList;

  @override
  void initState() {
    super.initState();
    InitManager.getInstance().initContext(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyLikeMePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("喜欢我的人"),
        centerTitle: true,
      ),
      body: EasyRefresh(
        emptyWidget: getEmptyWidget(),
        firstRefresh: true,
        header: BallPulseHeader(
          enableHapticFeedback: false,
        ),
        footer: BallPulseFooter(
          enableHapticFeedback: false,
        ),
        onRefresh: onRefresh,
        onLoad: noMore ? null : onLoad,
        child: GridView.count(
          crossAxisCount: 4,
          childAspectRatio: 0.618,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          children: List.generate(
            getChildCount(),
                (index) {
              return getChildWidget(index);
            },
          ),
        ),
      ),
    );
  }

  /// 后端默认20
  int pageSize = 20;

  /// getData负责+1
  int pageNum = 1; // 从1开始

  /// 默认没有更多, 只有当刷新成功了才有更多
  bool noMore = true;

  /// 网络失败则返回null, 成功则有数据
  Future<List<User>> getData() async {
    return await AppApi.getInstance().getUserLikeMe(context, pageNum);
  }

  /// 刷新页面
  /// 处理了: 网络异常, 第一页的分页, 还有更多的情况, 第一次加载展示加载的UI
  Future<void> onRefresh() async {
    pageNum = 1;
    List<User> orderData = await getData();
    // 只要网络请求回来, 就已经完成了第一次加载
    if (showedLoading) {
      showedLoading = false;
    }
    if (mounted) {
      setState(() {
        // 如果不是网络异常, 则不为空, 更新列表, 如果是网络异常则为空, 不更新
        if (orderData != null) {
          userList = orderData;
          noMore = false;
        }
      });
    }
  }

  /// 加载更多
  /// 处理了: 没有更多的情况, 网络失败的情况, 分页的情况
  Future<void> onLoad() async {
    pageNum++;
    List<User> orderData = await getData();
    if (mounted) {
      setState(() {
        if (orderData == null) {
          /// 网络失败
          pageNum--;
        } else if (orderData.length == 0) {
          noMore = true;
          userList.addAll(orderData);
          pageNum--;
        } else {
          noMore = false;
          userList.addAll(orderData);
        }
      });
    }
  }

  /// 是否已经展示过loading
  bool showedLoading = true;

  /// 空视图一个是第一次加载, 一个是网络错误orderList==null, 一个是数据是空数组orderList==[]
  /// 如果@return是null, 则不显示null
  Widget getEmptyWidget() {
    if (getChildCount() > 0) {
      return null;
    }
    if (showedLoading) {
      // 第一次加载
      return SearchResultEmptyWidget(
        title: "正在努力加载中",
      );
    } else if (userList == null) {
      // 不是第一次加载情况下仍然为空, 则肯定是网络错误
      return SearchResultEmptyWidget(
        title: "网络错误",
      );
    } else {
      // orderList==[]
      // 空界面的情况
      return SearchResultEmptyWidget();
    }
  }

  /// 获取子item的数值
  int getChildCount() {
    int count = (userList ?? List()).length;
    return count;
  }

  /// 获取item Widget
  Widget getChildWidget(int index) {
    print("${userList[index].userPhoto}");
    return GestureDetector(
      onTap: () {
        goPageView(index);
      },
      child: Card(
        child: CachedNetworkImage(
          imageUrl: userList[index].userPhoto,
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Image.asset(DevConstant.CONST_PIC),
        ),
      ),
    );
  }

  void goPageView(int index) {
    String userJson = json.encode(userList);
    String urlEncode = Uri.encodeComponent(userJson);
    AppController.navigateTo(context, AppRoutes.ROUTE_USER_VERTICAL + "?index=$index&userJson=$urlEncode");
  }
}


