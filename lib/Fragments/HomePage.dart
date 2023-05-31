
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_mucb/Fragments/CompletePage.dart';
import 'package:flutter_app_mucb/Fragments/InProgressPage.dart';
import 'package:flutter_app_mucb/Fragments/OnHoldPage.dart';
import 'package:flutter_app_mucb/Fragments/ReadyToReviewPage.dart';
import 'package:flutter_app_mucb/Fragments/ScheduledPage.dart';
import 'package:flutter_app_mucb/utils/Colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../navigationDrawer.dart';
import 'AssignedPage.dart';

class homePage extends StatefulWidget {
  static const String routeName = '/HomePage';
  final name;
  final userId;

  homePage({Key key, @required this.name, @required this.userId})
      : super(key: key);

  @override
  homePageState createState() => homePageState();
}

class homePageState extends State<homePage> {
  bool isLoading = false;

  static const String routeName = '/HomePage';

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: Scaffold(
        appBar: AppBar(
          title: Text("Dashboard"),
          backgroundColor: primaryColor,
        ),
        drawer: navigationDrawer(name: widget.name),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Image.asset('asset/images/app_logo.png',width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,),
                  )),
              FutureBuilder<List<Data>>(
                  future: fetchDashboardCount(widget.userId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      choices.clear();
                      choices.addAll(snapshot.data);
                    } else if (snapshot.hasError) {
                      Fluttertoast.showToast(
                          msg: "Failed to load dashboard count.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                    return GridView.count(
                        shrinkWrap: true,
                        childAspectRatio:
                            MediaQuery.of(context).size.height / 400,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        crossAxisCount: 2,
                        children: List.generate(choices.length, (index) {
                          return Center(
                            child: SelectCard(choice: choices[index], userId: widget.userId, name: widget.name,),
                          );
                        }));
                  })
              ,
              isLoading
                  ? Container(
                child: CircularProgressIndicator(),
                alignment: Alignment.center,
              )
                  : SizedBox(),
            ],
          ),
        )),
      onWillPop: _onWillPop);
  }

  // this is the future function called to show dialog for confirm exit.
  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Confirm Exit ?',
            style: new TextStyle(color: Colors.black, fontSize: 20.0)),
        content: new Text(
            'Are you sure you want to exit the app? Tap \'Yes\' to exit \'No\' to cancel.'),
        actions: <Widget>[
          new TextButton(
            onPressed: () {
              // this line exits the app.
              if(Platform.isAndroid){
                SystemChannels.platform
                    .invokeMethod('SystemNavigator.pop');
              } else {
                //MinimizeApp.minimizeApp();
              }

            },
            child:
            new Text('Yes', style: new TextStyle(fontSize: 18.0)),
          ),
          new TextButton(
            onPressed: () => Navigator.pop(context), // this line dismisses the dialog
            child: new Text('No', style: new TextStyle(fontSize: 18.0)),
          )
        ],
      ),
    ) ??
        false;
  }
}



Future<List<Data>> fetchDashboardCount(String userId) async {
  log("Dashboard UserId " + userId);
  final response = await http.post(
    Uri.https('''', 'api/inspection-status-count'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'user_id': userId}),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
      List jsonResponse = json.decode(response.body)["body"]["dashboard"];
      return jsonResponse.map((data) => new Data.fromJson(data)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Data {
  final int status_id;
  final int inspection_count;
  final String status_name;

  Data({this.status_id, this.inspection_count, this.status_name});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      status_id: json['status_id'],
      inspection_count: json['inspection_count'],
      status_name: json['status_name'],
    );
  }
}

List<Data> choices = <Data>[
  Data(status_name: 'Assigned', inspection_count: 0, status_id: 1),
  Data(status_name: 'Scheduled', inspection_count: 0, status_id: 2),
  Data(status_name: 'On-Hold', inspection_count: 0, status_id: 3),
  Data(status_name: 'In-Progress', inspection_count: 0, status_id: 4),
 // Data(status_name: 'Ready to Review', inspection_count: 0, status_id: 5),
  //Data(status_name: 'Completed', inspection_count: 0, status_id: 6),
];

class SelectCard extends StatelessWidget {

  const SelectCard({Key key, this.choice, this.userId, this.name}) : super(key: key);
  final Data choice;
  final  userId;
  final name;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        padding: EdgeInsets.only(right: 5, left: 5),
        child: InkWell(
            onTap: () {
              String routNo = choice.status_name;
              switch(routNo) {
                case "Assigned": {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            assignedPage(name: name, userId: userId),));
                }
                break;

                case "Scheduled": {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            scheduledPage(name: name, userId: userId),));
                }
                break;

                case "On-Hold": {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            onHoldPage(name: name, userId: userId),));
                }
                break;

                case "In-Progress": {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            inProgressPage(name: name, userId: userId),));
                }
                break;
                default: { print("Invalid choice"); }
                break;
              }
            },
        child: Card(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        ),
            child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        choice.status_name,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                      ),

                    ),
                    Divider(color: Colors.black),
                    Padding(
                      //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        choice.inspection_count.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ]),
            ))));
  }
}
