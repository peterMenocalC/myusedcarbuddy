import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_mucb/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';

import 'RefreshCallback.dart';


// ignore: must_be_immutable
class ErrorView extends StatelessWidget {
  bool _isCloseApp = false;
  String _message;

  ErrorView({isCloseApp = false, message = ""}) {
    _isCloseApp = isCloseApp;
    _message = message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'asset/images/error.png',
            height: 250,
            width: 250,
            fit: BoxFit.cover,
          ),
          30.height,
          Text(
            "Oops! " + _message,
            style: boldTextStyle(
              size: 24,
            ),
            textAlign: TextAlign.center,
          ),
          10.height,
          Text(
            "An error occurred",
            style: secondaryTextStyle(
              size: 14,
            ),
            textAlign: TextAlign.center,
          ).paddingOnly(left: 20, right: 20),
          AppBtn(
            value: "Please try again",
            onPressed: () {
              if (_isCloseApp) {
                SystemNavigator.pop();
              } else {
                Navigator.of(context).pop();
              }
            },
          ).paddingAll(16)
        ],
    ));
  }
}

Widget createErrorView(BuildContext context, String _message, RefreshDataCallback callback) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Image.asset(
        'asset/images/empty.png',
        height: 250,
        width: 250,
        fit: BoxFit.cover,
      ),
      30.height,
      Text(
        "Oops! " + _message,
        style: boldTextStyle(
          size: 24,
        ),
        textAlign: TextAlign.center,
      ),
      10.height,
      Text(
        "",
        style: secondaryTextStyle(
          size: 14,
        ),
        textAlign: TextAlign.center,
      ).paddingOnly(left: 20, right: 20),
      AppBtn(
        value: "Please try again",
        onPressed: () {
          callback.doRefresh();
        },
      ).paddingAll(16)
    ],
  );
}
