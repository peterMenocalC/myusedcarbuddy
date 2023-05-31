import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_mucb/Fragments/AssignedPage.dart';
import 'package:flutter_app_mucb/Fragments/ChangePasswordPage.dart';
import 'package:flutter_app_mucb/Fragments/CompletePage.dart';
import 'package:flutter_app_mucb/Fragments/InProgressPage.dart';
import 'package:flutter_app_mucb/Fragments/OnHoldPage.dart';
import 'package:flutter_app_mucb/Fragments/ReadyToReviewPage.dart';
import 'package:flutter_app_mucb/Fragments/ScheduledPage.dart';
import 'package:flutter_app_mucb/utils/Colors.dart';

import 'Fragments/HomePage.dart';
import 'Routes/pageRoute.dart';

class Home extends StatefulWidget {
  final name ;
  final userId;
  Home({
    Key key, @required this.name, @required this.userId}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'NavigationDrawer Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: primaryColor,
          )),
      home: homePage(name: widget.name, userId: widget.userId),
      routes:  {
        pageRoutes.home: (context) => homePage(name:widget.name, userId: widget.userId),
        pageRoutes.assigned: (context) => assignedPage(name:widget.name, userId: widget.userId),
        pageRoutes.scheduled: (context) => scheduledPage(name:widget.name, userId: widget.userId),
        pageRoutes.onhold: (context) => onHoldPage(name:widget.name, userId: widget.userId),
        pageRoutes.inprogress: (context) => inProgressPage(name:widget.name, userId: widget.userId),
        pageRoutes.readytoreview: (context) => readyToReviewPage(name:widget.name, userId: widget.userId),
        pageRoutes.completed: (context) => completePage(name:widget.name, userId: widget.userId),
        pageRoutes.changePassword: (context) => ChangePasswordPage(name:widget.name, userId: widget.userId),

      },
    );
  }
}