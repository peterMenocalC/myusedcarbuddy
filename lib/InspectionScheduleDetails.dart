import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app_mucb/utils/Colors.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import 'ErrorView.dart';
import 'InspectionOrderDetails.dart';
import 'InspectionVehicleDetails.dart';
import 'NoInternetConnection.dart';
import 'ScheduledInspectionDetails.dart';
import 'main.dart';
import 'model/InspectionDetails.dart';
import 'package:http/http.dart' as http;

class InspectionScheduleDetails extends StatefulWidget {
  final userId;
  final orderId;
  final status;

  InspectionScheduleDetails({
    Key key, @required this.userId, @required this.orderId, @required this.status}) : super(key: key);

  @override
  _InspectionScheduleDetailsState createState() => _InspectionScheduleDetailsState();
}

class _InspectionScheduleDetailsState extends State<InspectionScheduleDetails> implements ScheduleDialogCallback {
  bool mIsLoading = false;
  InspectionDetails inspectionDetails;
  final reasonController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInspectionOrderDetails();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    reasonController.dispose();
    super.dispose();
  }

  Future<void> getInspectionOrderDetails() async {
    setState(() {
      mIsLoading = true;
    });
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        log('data: ' + widget.orderId);
        await fetchOrderDetails(widget.userId, widget.orderId).then((
            res) async {
          mIsLoading = false;
          setState(() {
            inspectionDetails = res;
          });
        }).catchError((onError) {
          setState(() {
            mIsLoading = false;
          });
          //printLogs(onError.toString());
          ErrorView(
            message: onError.toString(),
          ).launch(context);
        });
      } else {
        setState(() {
          mIsLoading = false;
        });
        NoInternetConnection().launch(context);
      }
    });
  }

  Future<InspectionDetails> fetchOrderDetails(String userId,
      String orderId) async {
    log('data1: ' + orderId);
    final response = await http.post(
      Uri.https('''', 'api/inspection-all-details-by-order-id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'user_id': userId, 'order_id': orderId}),
    );
    log('data1: ' + 'after api call');


    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      log('data1: ' + response.body);
      return InspectionDetails.fromJson(
          json.decode(response.body)["body"]["inspection"]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      log('data1: ' + 'exception');

      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Inspection Details"),
          backgroundColor: primaryColor,
        ),
        body: Stack(
            children: [SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                        child: Text("Inspection", style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: 10, bottom: 10, top: 10),
                        child: Text("Assigned", style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    color: subHeaderBackground,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Center(
                      child: Text("Vehicle Details", style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold)),),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 3,
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Contact", style: TextStyle(fontSize: 14.0,),
                          textAlign: TextAlign.end,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Text(
                          inspectionDetails != null ? inspectionDetails
                              .salesPerson : "NA", style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 3,
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Contact Phone", style: TextStyle(fontSize: 14.0,),
                          textAlign: TextAlign.end,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Text(
                          inspectionDetails != null ? inspectionDetails
                              .salespersonPhone : "NA", style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 3,
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Dealership", style: TextStyle(fontSize: 14.0,),
                          textAlign: TextAlign.end,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Text(inspectionDetails != null
                            ? inspectionDetails.seller
                            : "NA", style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 3,
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Dealership Phone", style: TextStyle(fontSize: 14.0,),
                          textAlign: TextAlign.end,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Text(
                          inspectionDetails != null ? inspectionDetails
                              .sellerPhone : "NA", style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 3,
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Location", style: TextStyle(fontSize: 14.0,),
                          textAlign: TextAlign.end,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Text(inspectionDetails != null
                            ? inspectionDetails.location
                            : "NA", style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 3,
                        padding: EdgeInsets.only(top: 10),
                        child: Text("Buyer", style: TextStyle(fontSize: 14.0,),
                          textAlign: TextAlign.end,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Text(inspectionDetails != null
                            ? inspectionDetails.buyer
                            : "NA", style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 3,
                        padding: EdgeInsets.only(top: 10),
                        child: Text("Year", style: TextStyle(fontSize: 14.0,),
                          textAlign: TextAlign.end,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Text(inspectionDetails != null
                            ? inspectionDetails.carYear
                            : "NA", style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 3,
                        padding: EdgeInsets.only(top: 10),
                        child: Text("Make", style: TextStyle(fontSize: 14.0,),
                          textAlign: TextAlign.end,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Text(inspectionDetails != null
                            ? inspectionDetails.carMake
                            : "NA", style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 3,
                        padding: EdgeInsets.only(top: 10),
                        child: Text("Model", style: TextStyle(fontSize: 14.0,),
                          textAlign: TextAlign.end,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Text(inspectionDetails != null
                            ? inspectionDetails.carModel
                            : "NA", style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 3,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text("VIN", style: TextStyle(fontSize: 14.0,),
                          textAlign: TextAlign.end,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                        child: Text(
                          inspectionDetails != null ? inspectionDetails
                              .vehicleVin : "NA", style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    color: Colors.red,
                    width: MediaQuery. of(context). size. width,
                    child: Center(
                      child: Text("Requires scheduling", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white)),),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 40,
                    width: MediaQuery. of(context). size. width/2,
                    decoration: BoxDecoration(
                        color: Colors.white, border: Border.all(
                      color: Colors.black,
                      width: 1,
                    )),
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) { return new MyDialog(
                          callback: this,
                          // ignore: missing_return
                        ); });
                      },
                      child: Text(
                        'Schedule Inspection',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                  /*Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    width: MediaQuery. of(context). size. width,
                    child: Center(
                      child: Text("* Review and confirm order details while scheduling", style: TextStyle(fontSize: 13.0, fontStyle: FontStyle.italic, color: Colors.red)),),
                  ),*/
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 40,
                    width: MediaQuery. of(context). size. width/2,
                    decoration: BoxDecoration(
                        color: Colors.white, border: Border.all(
                      color: Colors.black,
                      width: 1,
                    )),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => InspectionOrderDetails(name: "name", orderDetails: inspectionDetails,)));
                      },
                      child: Text(
                        'View Order Details',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                  Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 30, left: 30, bottom: 10),
                        height: 40,
                        width: MediaQuery. of(context). size. width/3,
                        decoration: BoxDecoration(
                            color: primaryColor, borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Back',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30, right: 30, bottom: 10),
                        height: 40,
                        width: MediaQuery. of(context). size. width/3,
                        decoration: BoxDecoration(
                            color: Colors.green, borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (_) => InspectionOrderDetails(name: "name",orderDetails: inspectionDetails,)));
                          },
                          child: Text(
                            'Next',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ), mIsLoading
                ? Container(
              child: CircularProgressIndicator(),
              alignment: Alignment.center
              ,
            )
                : SizedBox(),
            ]));
  }

  @override
  void valueUpdated(String selectedDate, String AMorPM) {
    setState(() {
      mIsLoading = true;
    });
    doSchedule(widget.userId, widget.orderId, selectedDate ,AMorPM).then((value) =>
    {
      if(value.success) {
        Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => ScheduleInspectionDetails(userId: widget.userId, orderId: widget.orderId,)))
    }
    else {
        setState(() {
          mIsLoading = false;
        }),
        Fluttertoast.showToast(
            msg: "Failed - Schedule inspection.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0)
      } }
    ).catchError((e) {
      setState(() {
        mIsLoading = false;
      });
      Fluttertoast.showToast(
          msg: "Failed - Schedule inspection.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  Future<AcceptRejectResponse> doSchedule(String userId, String orderId, String scheduled_date, String aMorPM) async {
    log('data1: ' + orderId);
    final response = await http.post(
      Uri.https('''', 'api/inspection-schedule'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'user_id': userId , 'order_id': orderId, 'scheduled_date':scheduled_date, 'meridian':aMorPM.toUpperCase()}),
    );
    log('data1: ' + 'after api call');


    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      log('data1: ' + response.body);
      return AcceptRejectResponse.fromJson(json.decode(response.body));

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      log('data1: ' + 'exception');

      throw Exception('Failed to load data');
    }
  }

}

class MyDialog extends StatefulWidget {
  const MyDialog({this.callback});

  final ScheduleDialogCallback callback;

  @override
  State createState() => new MyDialogState();
}

class MyDialogState extends State<MyDialog> {
  String amPMRadioVal ="";
  DateTime selectedDate;
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: appStore.scaffoldBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)), //this right here
        child: Container(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          controller: controller,
                          style: TextStyle(
                            fontSize: 18,
                            color: appStore.appTextPrimaryColor,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(26, 18, 4, 18),
                            hintText: "Click here to select date",
                            filled: true,
                            hintStyle: TextStyle(color: appStore.textSecondaryColor),
                            fillColor: appStore.editTextBackColor,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white, width: 0.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white, width: 0.0),
                            ),
                          ),
                          onTap: () async {
                            // Below line stops keyboard from appearing
                            FocusScope.of(context).requestFocus(new FocusNode());
                            selectedDate = DateTime.now();
                            final DateTime pickedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime.now().subtract(Duration(days: 0)),
                                lastDate: DateTime(2050),);
                            // Show Date Picker Here
                            if (pickedDate != null && pickedDate != selectedDate)
                              setState(() {
                                selectedDate = pickedDate;
                                String formattedDate = DateFormat('yMMMMd').format(selectedDate);
                                log("date "+ formattedDate);
                                controller.text = formattedDate;
                              });
                          },
                        ),
                      ),
                      16.height,
                      /*Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 50),
                            child: Radio<String>(
                              value: "AM", onChanged: (String value) { setState(() {
                              amPMRadioVal = value;
                            }); }, groupValue: amPMRadioVal,
                            ),
                          ),
                          Text(
                            'AM',
                            style: new TextStyle(fontSize: 17.0),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 0),
                            child: Radio<String>(
                              value: "PM", onChanged: (String value) { setState(() {
                              amPMRadioVal = value;
                            }); }, groupValue: amPMRadioVal,
                            ),
                          ),
                          Text(
                            'PM',
                            style: new TextStyle(fontSize: 17.0),
                          ),
                        ],
                      ),*/
                      Container(
                        margin: EdgeInsets.only(top: 10,left: 40),
                        height: 40,
                        width: MediaQuery. of(context). size. width/2,
                        decoration: BoxDecoration(
                            color: primaryColor, border: Border.all(
                          color: Colors.black,
                          width: 1,
                        )),
                        child: TextButton(
                          onPressed: () {
                            if(selectedDate == null){
                              Fluttertoast.showToast(
                                  msg: "Please select date to schedule",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            else {
                              Navigator.of(context).pop();
                              String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
                              log("date "+ formattedDate);
                              widget.callback.valueUpdated(formattedDate, amPMRadioVal);
                            }
                          },
                          child: Text(
                            'Schedule',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),

                    ]

                )
            )

        )
    );
  }
}

abstract class ScheduleDialogCallback {
  void valueUpdated(String selectedDate, String AMorPM);
}