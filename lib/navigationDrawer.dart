import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_mucb/SharedPreferencesHelper.dart';
import 'package:flutter_app_mucb/Widget/createSubDrawerBodyItem.dart';
import 'package:flutter_app_mucb/main.dart';

import 'Widget/createDrawerBodyItem.dart';
import 'Widget/createDrawerHeader.dart';
import 'package:flutter_app_mucb/Routes/pageRoute.dart';

class navigationDrawer extends StatelessWidget {
  final name;

  navigationDrawer({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          createDrawerHeader(name),
          createDrawerBodyItem(
            icon: Icons.home,
            text: 'Home',
            onTap: () =>
                Navigator.pushReplacementNamed(context, pageRoutes.home),
          ),
          createDrawerBodyItem(text: 'Inspections'),
          createSubDrawerBodyItem(
              icon: Icons.fact_check_outlined,
              text: 'Assigned',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, pageRoutes.assigned)),
          createSubDrawerBodyItem(
              icon: Icons.schedule_sharp,
              text: 'Scheduled',
              onTap: () => Navigator.pushReplacementNamed(
                  context, pageRoutes.scheduled)),
          createSubDrawerBodyItem(
              icon: Icons.motion_photos_paused,
              text: 'On-Hold',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, pageRoutes.onhold)),
          createSubDrawerBodyItem(
              icon: Icons.hourglass_top,
              text: 'In Progress',
              onTap: () => Navigator.pushReplacementNamed(
                  context, pageRoutes.inprogress)),
          createDrawerBodyItem(
            icon: Icons.lock_open,
            text: 'Change Password',
              onTap: () => Navigator.pushReplacementNamed(
                  context, pageRoutes.changePassword)),
          createDrawerBodyItem(
            icon: Icons.logout,
            text: 'Logout',
            onTap: () => {
              SharedPreferencesHelper.clearPref(),
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => Login()))
            },
          ),
          ListTile(
            title: Text('App version 1.0.0'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
