import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget createSubDrawerBodyItem(
    {IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(left: 30.0),
          child: Icon(icon),),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}