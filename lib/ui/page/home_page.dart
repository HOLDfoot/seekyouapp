import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:seekyouapp/ui/constant/DevConstant.dart';

/// 会员购买记录
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List<UserInfo> userList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("寻觅"),
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
          childAspectRatio: 0.6,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          children: List.generate(
            getChildCount(),
            (index) {
              return getChildWidget(index);
            },
          ),
        ),
        /*
          child: ListView.builder(
            padding: EdgeInsets.only(top: adapt(4)),
            shrinkWrap: true,
            itemCount: getChildCount(),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return getChildWidget(index);
            },
          )
*/
      ),
    );
  }

  /// 后端默认10
  int pageSize = 10;

  /// getData负责+1
  int page = 0;

  /// 默认没有更多, 只有当刷新成功了才有更多
  bool noMore = true;

  /// 网络失败则返回null, 成功则有数据
  Future<List<UserInfo>> getData() async {
    UserInfo item = UserInfo(name: "小明", photo: DevConstant.CONST_PIC);
    List<UserInfo> userInfoList = [];
    for (int i = 0; i < pageSize; i++) {
      userInfoList.add(item);
    }
    print(DateTime.now());
    await Future.delayed(Duration(seconds: 3));
    print(DateTime.now());
    return userInfoList;
  }

  /// 刷新页面
  /// 处理了: 网络异常, 第一页的分页, 还有更多的情况, 第一次加载展示加载的UI
  Future<void> onRefresh() async {
    // 恢复初始值
    page = 1;
    List<UserInfo> orderData = await getData();
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
    page++;
    List<UserInfo> orderData = await getData();
    if (mounted) {
      setState(() {
        if (orderData == null) {
          /// 网络失败
          page--;
        } else if (orderData.length == 0) {
          noMore = true;
          userList.addAll(orderData);
          page--;
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
    return Card(
      child: CachedNetworkImage(
        imageUrl: userList[index].photo,
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
      /* child: Image.network(
        userList[index].photo,
        fit: BoxFit.cover,
        colorBlendMode: BlendMode.colorBurn,
        color: Colors.white10,
      ),*/
    );
  }

  double adapt(int dp) {
    return dp * 1.0;
  }
}

class UserInfo {
  String name;
  String email;
  String photo;
  String introduce;

  UserInfo({this.name, this.email, this.photo, this.introduce});
}

class SearchResultEmptyWidget extends StatelessWidget {
  final String title;

  SearchResultEmptyWidget({Key key, this.title = "没有数据"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(this.title);
  }
}

