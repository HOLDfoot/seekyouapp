import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:seekyouapp/app/provider/UserProvider.dart';
import 'package:seekyouapp/app/routers/navigate.dart';
import 'package:seekyouapp/app/routers/routers.dart';
import 'package:seekyouapp/data/manager/InitManager.dart';
import 'package:seekyouapp/data/manager/user_manager.dart';
import 'package:seekyouapp/platform/wrapper/service_locator.dart';
import 'package:seekyouapp/ui/page/home_page.dart';
import 'package:seekyouapp/ui/page/interest_page.dart';
import 'package:seekyouapp/ui/page/login_page.dart';
import 'package:seekyouapp/ui/page/mine_page.dart';

import 'app/provider/Counter.dart';
import 'data/manager/user.dart';

void main() {
  // 注册服务
  setupLocator();

  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  MyApp(): super() {
    InitManager.getInstance().init();
    final router = new FluroRouter();
    AppRoutes.configureRoutes(router);
    AppController.router = router;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return OKToast(
        child: MaterialApp(
          title: '遇见',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: BottomWidget(title: 'Flutter Demo Home Page'),
          onGenerateRoute: AppController.router.generator,
        ),
      );
  }
}

class BottomWidget extends StatefulWidget {
  BottomWidget({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _BottomWidgetState createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget> {
  List<StatefulWidget> pageList;
  int curPageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageList = [HomePage(), InterestPage(), MinePage()];
  }

  @override
  Widget build(BuildContext context) {

    bool isLogin = false;

    return Scaffold(
      body: pageList[curPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
          BottomNavigationBarItem(icon: Icon(Icons.add), title: Text("关注")),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text("我的")),
        ],
        iconSize: 40,
        currentIndex: curPageIndex,
        onTap: (int index) {
          if (AccountManager.getInstance().isLogin()) {
            setState(() {
              curPageIndex = index;
            });
          } else if (index != 0){
            /// 跳转到login界面
            Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
              return LoginPage();
            }));
          }
        },
      ),
    );
  }
}
