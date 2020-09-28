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

class ContactAuthorPage extends BaseStatefulPage {
  @override
  ContactAuthorState createState() {
    return ContactAuthorState();
  }
}

class ContactAuthorState extends BaseState<ContactAuthorPage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: backAppbar(context, "联系作者"),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                  width: adapt(300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "在使用App过程中遇到任何问题都可以给作者发邮件, 您的问题会被解答. 如果对App有任何建议也请大胆的提出来. 为了您的体验, 我们将努力的变得更好",
                        style: TextStyle(fontSize: 15),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: adapt(10)),
                      ),
                      Row(
                        children: [
                          Text(
                            "作者邮箱: ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          GestureDetector(
                            onTap: sendMail,
                            onLongPress: () {
                              Clipboard.setData(ClipboardData(
                                  text: ProductConstant.AUTHOR_EMAIL));
                              Fluttertoast.showToast(msg: "已复制到剪切板");
                            },
                            child: Text(
                              ProductConstant.AUTHOR_EMAIL,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                          Text(
                            " (长按复制)",
                            style: TextStyle(fontSize: sp(12)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: adapt(30)),
                      ),
                      Container(
                          width: adapt(248),
                          height: adapt(43),
                          margin: EdgeInsets.only(
                              top: adapt(20), bottom: adapt(20)),
                          child: FlatButton(
                            child: new Text(
                              "用邮箱给作者发邮件",
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF), fontSize: sp(15)),
                            ),
                            color: Color(0xFFFFD511),
                            onPressed: sendMail,
                            shape: new RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(adapt(22))),
                          ))
                    ],
                  )),
            ),
          ],
        ));
  }

  void sendMail() {
    User user = AccountManager.getInstance().getUser();

    String emailBody = """Hi 朱乐乐,
    我是用户${user.userName}(id: ${user.userId}, 注册邮箱: ${user.userEmail}),\n""";
    String uriEncode = Uri.encodeComponent(emailBody);
    TelAndSmsService.launchURL(ProductConstant.AUTHOR_EMAIL, "问题反馈", uriEncode);
  }
}
