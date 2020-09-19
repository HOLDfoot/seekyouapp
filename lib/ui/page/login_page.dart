import 'package:flutter/material.dart';
import 'package:seekyouapp/ui/constant/DevConstant.dart';

/// 登录
class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title = "登录"}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: 260,
          height: 300,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      color: Colors.red,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              Row(
                children: [

                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
