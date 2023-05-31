import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_mucb/Routes/pageRoute.dart';
import 'package:flutter_app_mucb/model/InspectionRequestListData.dart';
import 'package:flutter_app_mucb/utils/Colors.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:nb_utils/nb_utils.dart';

import '../ErrorView.dart';
import '../NoInternetConnection.dart';
import '../RefreshCallback.dart';
import '../navigationDrawer.dart';
import 'package:http/http.dart' as http;

import 'HomePage.dart';

class readyToReviewPage extends StatefulWidget {
  static const String routeName = '/readyToReviewPage';
  final name;
  final userId;

  readyToReviewPage({Key key, @required this.name, @required this.userId})
      : super(key: key);

  @override
  _readyToReviewPageState createState() => _readyToReviewPageState();
}

class _readyToReviewPageState extends State<readyToReviewPage> implements RefreshDataCallback {
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
    if(mIsLoading) {
      return;
    }
    setState(() {
      mIsLoading = true;
    });
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await fetchRequestListData(widget.userId, "6").then((res) async {
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
              title: Text("Ready to review"),
            ),
            drawer: navigationDrawer(name: widget.name),
            body: new Stack(
              children: [
                Column(children: [
            Visibility(visible: !isErrorOccured,  child: Padding(
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
                  ),),
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
                                    );
                                  }).toList()))),
                ]),
                Visibility(
                    visible: isErrorOccured,
                    child: createErrorView(context, "No task ready to review", this)),
                mIsLoading
                    ? Container(
                        child: CircularProgressIndicator(),
                        alignment: Alignment.center,
                      )
                    : SizedBox(),
              ],
            ))), onWillPop: _onWillPop,);
  }

  // this is the future function called to show dialog for confirm exit.
  Future<bool> _onWillPop() {
    return  Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => homePage(name: widget.name, userId: widget.userId)));
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
}

class SelectCard extends StatelessWidget {
  const SelectCard(
      {Key key, this.report, @required this.userId})
      : super(key: key);
  final InspectionRequestListData report;
  final userId;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Text(report.carYear +
                    " " +
                    report.carMake +
                    " " +
                    report.carModel),
                subtitle: Text(report.location),
                trailing: Text(report.timeAge),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  report.salesPerson,
                  style: TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
        ));
  }
}
