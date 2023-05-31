import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_mucb/Routes/pageRoute.dart';
import 'package:flutter_app_mucb/SharedPreferencesHelper.dart';
import 'package:flutter_app_mucb/model/InspectionRequestListData.dart';
import 'package:flutter_app_mucb/model/StartInspectionData.dart';
import 'package:flutter_app_mucb/utils/Colors.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:nb_utils/nb_utils.dart';

import '../ErrorView.dart';
import '../NoInternetConnection.dart';
import '../RefreshCallback.dart';
import '../StartInspection.dart';
import '../navigationDrawer.dart';
import 'package:http/http.dart' as http;

import 'HomePage.dart';

class inProgressPage extends StatefulWidget {
  static const String routeName = '/inProgressPage';
  final name;
  final userId;

  inProgressPage({Key key, @required this.name, @required this.userId})
      : super(key: key);

  @override
  _inProgressPageState createState() => _inProgressPageState();
}

class _inProgressPageState extends State<inProgressPage>
    implements RefreshDataCallback , StartInspectionCallback {
  final ScrollController scrollController = ScrollController();
  bool mIsLoading = false;
  bool isErrorOccured = false;
  List<InspectionRequestListData> inspectionRequestList = List();
  List<InspectionRequestListData> searchresult = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRequestListData();
  }

  Future getRequestListData() async {
    if (mIsLoading) {
      return;
    }
    setState(() {
      mIsLoading = true;
    });
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await fetchRequestListData(widget.userId, "5").then((res) async {
          setState(() {
            mIsLoading = false;
            isErrorOccured = false;
            inspectionRequestList.addAll(res);
          });
        }).catchError((onError) {
          setState(() {
            mIsLoading = false;
            isErrorOccured = true;
          });
        });
      } else {
        setState(() {
          mIsLoading = false;
        });
        NoInternetConnection().launch(context);
      }
    });
  }

  Future<List<InspectionRequestListData>> fetchRequestListData(
      String userId, String statusId) async {
    log("<<<userId " + userId + " status id " + statusId);
    final response = await http.post(
      Uri.https('''', 'api/inspection-details-by-status'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'user_id': userId, 'status_id': statusId}),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List jsonResponse = json.decode(response.body)["body"]["inspection"];
      return jsonResponse
          .map((inspectionRequestListData) =>
              new InspectionRequestListData.fromJson(inspectionRequestListData))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: FocusDetector(
        onFocusGained: () {
          doRefresh();
        },
        child: new Scaffold(
            appBar: AppBar(
              title: Text("In Progress"),
            ),
            drawer: navigationDrawer(name: widget.name),
            body: new Stack(
              children: [
                Column(children: [
                  Visibility(
                      visible: !isErrorOccured,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 10, bottom: 0),
                        //padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          onChanged: searchOperation,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.search,
                              color: primaryColor,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: inactiveIconColor, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: inactiveIconColor, width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Search',
                            labelStyle: TextStyle(color: inactiveIconColor),
                            hintText: 'Enter data you want to search',
                            hintStyle: TextStyle(color: inactiveIconColor),
                          ),
                        ),
                      )),
                  Expanded(
                      child: Scrollbar(
                          isAlwaysShown: true,
                          controller: scrollController,
                          child: searchresult.length != 0
                              ? ListView(
                                  padding: EdgeInsets.all(8.0),
                                  physics: const ScrollPhysics(),
                                  children: List.generate(searchresult.length,
                                      (index) {
                                    return SelectCard(
                                      report: searchresult[index],
                                      userId: widget.userId,
                                      callback: this
                                    );
                                  }).toList())
                              : ListView(
                                  padding: EdgeInsets.all(8.0),
                                  physics: const ScrollPhysics(),
                                  children: List.generate(
                                      inspectionRequestList.length, (index) {
                                    return SelectCard(
                                      report: inspectionRequestList[index],
                                      userId: widget.userId,
                                        callback: this
                                    );
                                  }).toList()))),
                ]),
                Visibility(
                    visible: isErrorOccured,
                    child: createErrorView(
                        context, "No task is in progress", this)),
                mIsLoading
                    ? Container(
                        child: CircularProgressIndicator(),
                        alignment: Alignment.center,
                      )
                    : SizedBox(),
              ],
            )),
      ),
      onWillPop: _onWillPop,
    );
  }

// this is the future function called to show dialog for confirm exit.
  Future<bool> _onWillPop() {
    return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) =>
                homePage(name: widget.name, userId: widget.userId)));
  }

  void searchOperation(String searchText) {
    setState(() {
      searchresult.clear();
      for (int i = 0; i < inspectionRequestList.length; i++) {
        InspectionRequestListData report = inspectionRequestList[i];
        String data =
            report.carYear + " " + report.carMake + " " + report.carModel;
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchresult.add(report);
        }
      }
    });
  }

  @override
  void doRefresh() {
    inspectionRequestList.clear();
    getRequestListData();
  }

  @override
  void valueUpdated(userId, InspectionRequestListData report) {
    performStartInspection(context,userId,report);
  }


  Future<void> performStartInspection(BuildContext context,userId, InspectionRequestListData report) async {
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        setState(() {
          mIsLoading = true;
        });
        await startInspection(userId, report.orderId.toString())
            .then((res) async {
          for (int i = 0; i < res.categories.length; i++) {
            Category category = res.categories[i];
            for (int j = 0; j < category.sub_categories.length; j++) {
              SubCategory subCategory = category.sub_categories[j];
              SharedPreferencesHelper.setSubCategoryIdStatusCompleted(
                  report.orderId.toString(),
                  subCategory.id.toString(),
                  category.sub_categories[j].is_all_answered == 0
                      ? false
                      : true);
            }
          }
          mIsLoading = false;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => StartInspection(
                    categories: res.categories,
                    position: 0,
                    subCategoryPosition: 0,
                    userId: userId,
                    orderId: report.orderId.toString(),
                    vehicleData: report,
                  )));
        }).catchError((onError) {
          mIsLoading = false;
          ErrorView(
            message: onError.toString(),
          ).launch(context);
        });
      } else {
        NoInternetConnection().launch(context);
      }
    });
  }

  Future<StartInspectionData> startInspection(
      String userId, String orderId) async {
    log('data1: ' + orderId);
    final response = await http.post(
      Uri.https('''', 'api/inspection-start-inspection'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
      jsonEncode(<String, String>{'user_id': userId, 'order_id': orderId}),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      log('data1: ' + response.body);
      return StartInspectionData.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      log('data1: ' + 'exception');

      throw Exception('Failed to load data');
    }
  }

}

class SelectCard extends StatelessWidget {
  const SelectCard({Key key, this.report, @required this.userId,@required this.callback})
      : super(key: key);
  final InspectionRequestListData report;
  final userId;
  final StartInspectionCallback callback;

  @override
  Widget build(BuildContext context) {
    return Container(
        /*child: InkWell(
            onTap: () {
              performStartInspection(context);
            },*/
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                      onTap: () {
                        callback.valueUpdated(userId, report);
                        //performStartInspection(context);
                      },
                  child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        5.height,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "Order : " + report.orderId.toString(),
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        5.height,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "Scheduled on : " + report.scheduleDate,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                ),
                          ),
                        ),
                        ListTile(
                          title: Text(report.carYear +
                              " " +
                              report.carMake +
                              " " +
                              report.carModel),
                          subtitle: Text(report.seller),
                          trailing: Text(report.timeAge),
                        ),
                       /* Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            report.seller,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),*/
                      ])),
                  InkWell(
                    onTap: () {
                      log('In tap button');
                      MapsLauncher.launchQuery(
                          report.location);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                    child: new Text(report.location,style: TextStyle(fontSize: 16,decoration: TextDecoration.underline)),
                    )
                  )
                ],
              ),
            ));
  }

  Future<void> performStartInspection(BuildContext context) async {
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await startInspection(userId, report.orderId.toString())
            .then((res) async {
          for (int i = 0; i < res.categories.length; i++) {
            Category category = res.categories[i];
            for (int j = 0; j < category.sub_categories.length; j++) {
              SubCategory subCategory = category.sub_categories[j];
              SharedPreferencesHelper.setSubCategoryIdStatusCompleted(
                  report.orderId.toString(),
                  subCategory.id.toString(),
                  category.sub_categories[j].is_all_answered == 0
                      ? false
                      : true);
            }
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => StartInspection(
                        categories: res.categories,
                        position: 0,
                        subCategoryPosition: 0,
                        userId: userId,
                        orderId: report.orderId.toString(),
                        vehicleData: report,
                      )));
        }).catchError((onError) {
          ErrorView(
            message: onError.toString(),
          ).launch(context);
        });
      } else {
        NoInternetConnection().launch(context);
      }
    });
  }

  Future<StartInspectionData> startInspection(
      String userId, String orderId) async {
    log('data1: ' + orderId);
    final response = await http.post(
      Uri.https('''', 'api/inspection-start-inspection'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, String>{'user_id': userId, 'order_id': orderId}),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      log('data1: ' + response.body);
      return StartInspectionData.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      log('data1: ' + 'exception');

      throw Exception('Failed to load data');
    }
  }
}

abstract class StartInspectionCallback {
  void valueUpdated(final userId, InspectionRequestListData report);
}
