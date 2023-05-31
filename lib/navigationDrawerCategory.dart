import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_mucb/SharedPreferencesHelper.dart';
import 'package:flutter_app_mucb/StartInspection.dart';
import 'package:flutter_app_mucb/Widget/createSubDrawerBodyItem.dart';
import 'package:flutter_app_mucb/model/InspectionRequestListData.dart';
import 'package:flutter_app_mucb/model/StartInspectionData.dart';

import 'Widget/createDrawerBodyItem.dart';
import 'Widget/createDrawerHeader.dart';
import 'package:flutter_app_mucb/Routes/pageRoute.dart';

class navigationDrawerCategory extends StatelessWidget {
  final List<Category> list;
  final userid;
  final orderid;
  final InspectionRequestListData vehicleData;

  navigationDrawerCategory({Key key, @required this.list, @required this.userid, @required this.orderid, this.vehicleData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      margin: EdgeInsets.only(top: 20),
      child: ListView(
          padding: EdgeInsets.all(20.0),
          physics: const ScrollPhysics(),
          children: List.generate(list.length, (index) {
            return DrawerChild(
              subCategory: list,
              position: index,
              userid: userid,
              orderid: orderid,
              vehicleData: vehicleData,
            );
          }).toList()),
    ));
  }
}

class DrawerChild extends StatelessWidget {
  final InspectionRequestListData vehicleData;

  const DrawerChild({Key key, this.subCategory, this.position,  @required this.userid, @required this.orderid, this.vehicleData})
      : super(key: key);
  final List<Category> subCategory;
  final int position;
  final userid;
  final orderid;

  @override
  Widget build(BuildContext context) {
    Category data = subCategory[position];
    return Container(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Text(data.title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16),),
          ),
          ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 20.0),
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(data.sub_categories.length, (index) {
                return DrawerChildStateFullWidget(
                  subCategory: data.sub_categories,
                  subCategoryPosition: index,
                  position: position,
                  category: subCategory,
                  userid: userid,
                  orderid: orderid,
                  vehicleData: vehicleData,
                );
              }).toList())
        ],
      ),
    );
  }
}

class DrawerChildStateFullWidget extends StatefulWidget {

  final InspectionRequestListData vehicleData;

  const DrawerChildStateFullWidget(
      {Key key, this.subCategory, this.position, this.category, this.subCategoryPosition,  @required this.userid, @required this.orderid, this.vehicleData})
      : super(key: key);
  final List<SubCategory> subCategory;
  final int position;
  final int subCategoryPosition;
  final List<Category> category;
  final userid;
  final orderid;
  @override
  DrawerChildChild createState() {
    return DrawerChildChild();
  }
}

class DrawerChildChild extends State<DrawerChildStateFullWidget> {
  bool statusCheck = false;
  @override
  Widget build(BuildContext context) {

    SubCategory data = widget.subCategory[widget.subCategoryPosition];
    getStatusIcon(data.id);
    return Container(
        height: 50,
        child: InkWell(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => StartInspection(
                          categories: widget.category,
                          position: widget.position,
                          subCategoryPosition: widget.subCategoryPosition, userId: widget.userid, orderId: widget.orderid,
                      vehicleData: widget.vehicleData,
                        )));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
           Row(
          mainAxisSize: MainAxisSize.min,
            children: [
              if(statusCheck)
               Icon(Icons.check_circle_outline,color: Colors.green),
              Text(
                data.title,
                style: TextStyle(fontSize: 14),
              ),
              ]),
              Divider()
            ],
          ),
        ));
  }

  getStatusIcon(int id)  {
     SharedPreferencesHelper.getSubCategoryIdStatusCompleted(widget.orderid, id.toString()).then((value) => {
      setState((){
        statusCheck = value;
      })
    });
  }
}
