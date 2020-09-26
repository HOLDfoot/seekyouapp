
import 'package:flutter/material.dart';

class BaseDialog extends Dialog {

  const BaseDialog({
    Key key,
    Widget child
  }) : super(key: key, child: child, backgroundColor: Colors.transparent);

}