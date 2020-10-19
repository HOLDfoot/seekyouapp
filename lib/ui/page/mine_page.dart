import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:seekyouapp/app/provider/UserProvider.dart';
import 'package:seekyouapp/app/routers/navigate.dart';
import 'package:seekyouapp/app/routers/routers.dart';
import 'package:seekyouapp/data/manager/user.dart';
import 'package:seekyouapp/data/manager/user_manager.dart';
import 'package:seekyouapp/net/api/app_api.dart';
import 'package:seekyouapp/net/service/result_data.dart';
import 'package:seekyouapp/net/widget/dialog_param.dart';
import 'package:seekyouapp/net/widget/loading_dialog.dart';
import 'package:seekyouapp/ui/constant/dev_constant.dart';
import 'package:seekyouapp/util/logger.dart';
import 'package:seekyouapp/util/path_util.dart';
import 'package:seekyouapp/util_set.dart';

/// 我的
class MinePage extends StatefulWidget {
  MinePage({Key key, this.title = "设置"}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;

  Logger logger;

  @override
  void initState() {
    logger = new Logger(runtimeType.toString());
    super.initState();
    //监听滚动事件，打印滚动位置
    int hideOffsets = 140;
    _scrollController.addListener(() {
      if (_scrollController.offset >= hideOffsets &&
          _showAppBarTitle == false) {
        setState(() {
          _showAppBarTitle = true;
        });
      } else if (_scrollController.offset < hideOffsets &&
          _showAppBarTitle == true) {
        setState(() {
          _showAppBarTitle = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
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
      body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).cardColor,
                expandedHeight: 236,
                pinned: true,
                floating: false,
                snap: false,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: GestureDetector(
                    onTap: () {
                      /// 个人信息
                      AppController.navigateTo(context, AppRoutes.ROUTE_SETTING_MINE);
                    },
                    child: Stack(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints.expand(),
                          child: Image.asset(
                            "assets/images/ic_mine_header_bg.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(top: 50 + 56.0, left: 50),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 20),
                                  child: GestureDetector(
                                    onTap: () {
                                      _choosePhoto(context);
                                    },
                                    child:ClipOval(
                                      child: FadeInImage.assetNetwork(
                                        placeholder: DevConstant.CONST_PLACEHOLDER,
                                        fit: BoxFit.cover,
                                        image: context.watch<UserProvider>().userPhoto,
                                        //image: DevConstant.CONST_PIC_GIRL,
                                        width: 80,
                                        height: 80,
                                      ),
                                    )
                                  ),
                                ),
                                Container(
                                  height: 80,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 20),
                                      ),
                                      Text(
                                        context.watch<UserProvider>().userName,
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10),
                                      ),
                                      Text(context.watch<UserProvider>().userDesc),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                leading: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                title: InkWell(
                  child: Text(
                    _showAppBarTitle ? "新世界" : "",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  onTap: () {},
                ),
                centerTitle: true,
                actions: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Icon(Icons.settings),
                    ],
                  ),
                ],
              )
            ];
          },
          body: Container(
            child: Column(
              children: [
                getLineWidget(title: "设置", icon: Icons.settings, callback: () {
                  AppController.navigateTo(context, AppRoutes.ROUTE_SETTING);
                }),
                getLineWidget(title: "关注我的人", icon: Icons.person_add),
                getLineWidget(title: "喜欢的文章", icon: Icons.art_track),
              ],
            ),
          )),
    );
  }

  Widget getLineWidget({String title, IconData icon, Function callback}) {
    return GestureDetector(
      onTap: () {
        if (callback != null) {
          callback();
        }
      },
      child: Container(
          height: 50,
          color: Color(0xFFF3F5F9),
          margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(title),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(icon),
              )
            ],
          )),
    );
  }

  _choosePhoto(BuildContext context) async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    final File file = File(pickedFile.path);
    _compressImage(file);
  }

  _compressImage(File imageFile) async {
    ShowParam showParam =
    new ShowParam(barrierDismissible: false, showBackground: true);
    showParam.text = "正在上传头像...";
    LoadingDialogUtil.showTextLoadingDialog(context, showParam);
    int length = await imageFile.length();
    int times = 0;
    while (length >= 1 * 1024 * 1024) {
      // 文件大小大于1M
      List<int> byteList = await FlutterImageCompress.compressWithFile(
          imageFile.path,
          quality: 95 - times * 10); //  quality: 95 默认
      String appPath = await DirectoryUtil.getDocumentsDirectory();
      File result = File(appPath + "/photo.png");
      await result.writeAsBytes(byteList);
      imageFile = result;
      length = await result.length();
      times++;
    }
    ResultData resultData =
    await AppApi.getInstance().uploadUserIcon(context, imageFile);
    showParam.pop();
    String userPhoto = resultData.data["userPhoto"];
    User user = AccountManager.getInstance().getUser();
    user.userPhoto = userPhoto;
    AccountManager.getInstance().cacheUser(user);
    context.read<UserProvider>().updatePhoto(userPhoto);

    //AccountManager.getInstance().updateUser(user);
  }

  String userPhoto =
      "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1993946481,547847354&fm=26&gp=0.jpg";
}