import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_mucb/InspectionScheduleDetails.dart';
import 'package:flutter_app_mucb/model/InspectionDetails.dart';
import 'package:flutter_app_mucb/utils/Colors.dart';
import 'package:http/io_client.dart';
import 'package:nb_utils/nb_utils.dart';

import 'ErrorView.dart';
import 'NoInternetConnection.dart';
import 'package:http/http.dart' as http;

class InspectionAcceptVehicleDetails extends StatefulWidget {
  final userId;
  final orderId;
  final status;

  InspectionAcceptVehicleDetails({
    Key key, @required this.userId, @required this.orderId, @required this.status}) : super(key: key);

  @override
  _InspectionAcceptVehicleDetailsState createState() => _InspectionAcceptVehicleDetailsState();
}

class _InspectionAcceptVehicleDetailsState extends State<InspectionAcceptVehicleDetails> {
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
        await fetchOrderDetails(widget.userId, widget.orderId).then((res) async {
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

  Future<InspectionDetails> fetchOrderDetails(String userId, String orderId) async {
    log('data1: ' + orderId);

    final response = await http.post(
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'user_id': userId , 'order_id': orderId}),
    );
    log('data1: ' + 'after api call');


    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      log('data1: ' + response.body);
      return InspectionDetails.fromJson(json.decode(response.body)["body"]["inspection"]);

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
            children: [SingleChildScrollView (
              child: Column (
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                        child: Text("Inspection", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10, bottom: 10, top: 10),
                        child: Text("Assigned", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    color: subHeaderBackground,
                    width: MediaQuery. of(context). size. width,
                    child: Center(
                      child: Text("Vehicle Details", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width:  MediaQuery. of(context). size. width/3,
                        padding: EdgeInsets.only(top: 10),
                        child: Text("Contact", style: TextStyle(fontSize: 14.0, ),textAlign: TextAlign.end,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Text(inspectionDetails!=null ? inspectionDetails.salesPerson : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width:  MediaQuery. of(context). size. width/3,
                        padding: EdgeInsets.only(top: 10),
                        child: Text("Contact Phone", style: TextStyle(fontSize: 14.0, ),textAlign: TextAlign.end,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Text(inspectionDetails!=null ? inspectionDetails.salespersonPhone : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width:  MediaQuery. of(context). size. width/3,
                        padding: EdgeInsets.only(top: 10),
                        child: Text("Dealership", style: TextStyle(fontSize: 14.0, ),textAlign: TextAlign.end,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Text(inspectionDetails!=null ? inspectionDetails.seller : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width:  MediaQuery. of(context). size. width/3,
                        padding: EdgeInsets.only(top: 10),
                        child: Text("Dealership Phone", style: TextStyle(fontSize: 14.0, ),textAlign: TextAlign.end,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Text(inspectionDetails!=null ? inspectionDetails.sellerPhone : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width:  MediaQuery. of(context). size. width/3,
                        padding: EdgeInsets.only(top: 10),
                        child: Text("Location", style: TextStyle(fontSize: 14.0, ),textAlign: TextAlign.end,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Text(inspectionDetails!=null ? inspectionDetails.location : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width:  MediaQuery. of(context). size. width/3,
                        padding: EdgeInsets.only(top: 10),
                        child: Text("Buyer", style: TextStyle(fontSize: 14.0, ),textAlign: TextAlign.end,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Text(inspectionDetails!=null ? inspectionDetails.buyer : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width:  MediaQuery. of(context). size. width/3,
                        padding: EdgeInsets.only(top: 10),
                        child: Text("Year", style: TextStyle(fontSize: 14.0, ),textAlign: TextAlign.end,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Text(inspectionDetails!=null? inspectionDetails.carYear : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width:  MediaQuery. of(context). size. width/3,
                        padding: EdgeInsets.only(top: 10),
                        child: Text("Make", style: TextStyle(fontSize: 14.0, ),textAlign: TextAlign.end,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Text(inspectionDetails!=null? inspectionDetails.carMake : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width:  MediaQuery. of(context). size. width/3,
                        padding: EdgeInsets.only(top: 10),
                        child: Text("Model", style: TextStyle(fontSize: 14.0, ),textAlign: TextAlign.end,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Text(inspectionDetails!=null? inspectionDetails.carModel : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width:  MediaQuery. of(context). size. width/3,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text("VIN", style: TextStyle(fontSize: 14.0, ),textAlign: TextAlign.end,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                        child: Text(inspectionDetails!=null? inspectionDetails.vehicleVin : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    color: subHeaderBackground,
                    width: MediaQuery. of(context). size. width,
                    child: Center(
                      child: Text("You have accepted the inspection", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                    child: Text(inspectionDetails!=null ? "Your Fee: \$" + inspectionDetails.inspectorFee.toString() : "No package price detail", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 30),
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
                        margin: EdgeInsets.only(top: 10, right: 30),
                        height: 40,
                        width: MediaQuery. of(context). size. width/3,
                        decoration: BoxDecoration(
                            color: Colors.green, borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (_) => InspectionScheduleDetails(userId: widget.userId, orderId: widget.orderId,)));
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
            ),mIsLoading
                ? Container(
              child: CircularProgressIndicator(),
              alignment: Alignment.center
              ,
            )
                : SizedBox(),]));
  }
}

