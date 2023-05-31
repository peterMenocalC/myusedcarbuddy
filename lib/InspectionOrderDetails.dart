import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_mucb/model/InspectionDetails.dart';
import 'package:flutter_app_mucb/utils/Colors.dart';

class InspectionOrderDetails extends StatelessWidget {
  final name;
  final InspectionDetails orderDetails;
  InspectionOrderDetails({
    Key key, @required this.name, @required this.orderDetails}) : super(key: key);


/*  widget.vehicleData.salesPerson != null
  ? widget.vehicleData.salesPerson
      : "NA"*/
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Order Details"),
          backgroundColor: primaryColor,
        ),
        body: Column(
            children: [
              Expanded(child: SingleChildScrollView (
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
                          child: Text("Scheduled", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      color: subHeaderBackground,
                      width: MediaQuery. of(context). size. width,
                      child: Center(
                        child: Text("Order Details", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      color: Colors.black12,
                      width: MediaQuery. of(context). size. width,
                      child: Center(
                        child: Text("Product", style: TextStyle(fontSize: 15.0)),),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text(orderDetails.carMake +" " +orderDetails.carModel + " " + orderDetails.carYear, style: TextStyle(fontSize: 14.0, ),textAlign: TextAlign.end,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, right: 10),
                          child: Text (orderDetails.inspectorFee.toString() != null
                              ? "Total \$" + orderDetails.inspectorFee.toString()
                              : "NA" , style: TextStyle(fontSize: 14.0, ),),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      color: Colors.black12,
                      width: MediaQuery. of(context). size. width,
                      child: Center(
                        child: Text("Additional Details", style: TextStyle(fontSize: 15.0)),),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width:  MediaQuery. of(context). size. width/3,
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("Dealership", style: TextStyle(fontSize: 14.0, )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text(orderDetails.seller != null || orderDetails.seller.isNotEmpty
                              ? orderDetails.seller
                              : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width:  MediaQuery. of(context). size. width/3,
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("Phone", style: TextStyle(fontSize: 14.0, )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text(orderDetails.sellerPhone != null && orderDetails.sellerPhone.isNotEmpty
                              ? orderDetails.sellerPhone
                              : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width:  MediaQuery. of(context). size. width/3,
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("Salesperson", style: TextStyle(fontSize: 14.0, )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text(orderDetails.salesPerson != null && orderDetails.salesPerson.isNotEmpty
                              ? orderDetails.salesPerson
                              : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width:  MediaQuery. of(context). size. width/3,
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("Phone", style: TextStyle(fontSize: 14.0, )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text(orderDetails.salespersonPhone != null && orderDetails.salespersonPhone.isNotEmpty
                              ? orderDetails.salespersonPhone
                              : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    /*Row(
                      children: <Widget>[
                        Container(
                          width:  MediaQuery. of(context). size. width/3,
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("Add. Details", style: TextStyle(fontSize: 14.0, )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text(" Add. details goes here ", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),*/
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      color: Colors.black12,
                      width: MediaQuery. of(context). size. width,
                      child: Center(
                        child: Text("Vehicle Location", style: TextStyle(fontSize: 15.0)),),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width:  MediaQuery. of(context). size. width/3,
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("Address", style: TextStyle(fontSize: 14.0, )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text(orderDetails.location != null && orderDetails.location.isNotEmpty
                              ? orderDetails.location
                              : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width:  MediaQuery. of(context). size. width/3,
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("City", style: TextStyle(fontSize: 14.0, )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text(orderDetails.vehicleCity != null && orderDetails.vehicleCity.isNotEmpty
                              ? orderDetails.vehicleCity
                              : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width:  MediaQuery. of(context). size. width/3,
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("State", style: TextStyle(fontSize: 14.0, )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text(orderDetails.vehicleState != null && orderDetails.vehicleState.isNotEmpty
                              ? orderDetails.vehicleState
                              : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width:  MediaQuery. of(context). size. width/3,
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("Zip", style: TextStyle(fontSize: 14.0, )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text(orderDetails.vehicleLocationZip != null && orderDetails.vehicleLocationZip.isNotEmpty
                              ? orderDetails.vehicleLocationZip
                              : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      color: Colors.black12,
                      width: MediaQuery. of(context). size. width,
                      child: Center(
                        child: Text("Vehicle Details", style: TextStyle(fontSize: 15.0)),),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width:  MediaQuery. of(context). size. width/3,
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("Year", style: TextStyle(fontSize: 14.0, )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text(orderDetails.carYear != null && orderDetails.carYear.isNotEmpty
                              ? orderDetails.carYear
                              : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width:  MediaQuery. of(context). size. width/3,
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("Make", style: TextStyle(fontSize: 14.0, )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text(orderDetails.carMake != null && orderDetails.carMake.isNotEmpty
                              ? orderDetails.carMake
                              : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width:  MediaQuery. of(context). size. width/3,
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("Model", style: TextStyle(fontSize: 14.0, )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text(orderDetails.carModel != null && orderDetails.carModel.isNotEmpty
                              ? orderDetails.carModel
                              : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width:  MediaQuery. of(context). size. width/3,
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("VIN", style: TextStyle(fontSize: 14.0, )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text(orderDetails.vehicleVin != null && orderDetails.vehicleVin.isNotEmpty
                              ? orderDetails.vehicleVin
                              : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      color: Colors.black12,
                      width: MediaQuery. of(context). size. width,
                      child: Center(
                        child: Text("Customer", style: TextStyle(fontSize: 15.0)),),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width:  MediaQuery. of(context). size. width/3,
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("Company", style: TextStyle(fontSize: 14.0, )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text(orderDetails.buyerCompany != null && orderDetails.buyerCompany.isNotEmpty
                              ? orderDetails.buyerCompany
                              : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width:  MediaQuery. of(context). size. width/3,
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("First Name", style: TextStyle(fontSize: 14.0, )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text(orderDetails.buyer!= null
                              ? orderDetails.buyer
                              : "NA", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    /*Row(
                      children: <Widget>[
                        Container(
                          width:  MediaQuery. of(context). size. width/3,
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("Last Name", style: TextStyle(fontSize: 14.0, )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("Last Name goes here", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),*/
                   /* Container(
                      margin: EdgeInsets.only(top: 20, bottom: 10),
                      height: 40,
                      width: MediaQuery. of(context). size. width/3,
                      decoration: BoxDecoration(
                          color: Colors.white, border: Border.all(
                        color: Colors.black,
                        width: 1,
                      )),
                      child: TextButton(
                        onPressed: () {
                          // open calendar
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                    ),*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 30, bottom: 10),
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
                          margin: EdgeInsets.only(top: 10, right: 30, bottom: 10),
                          height: 40,
                          width: MediaQuery. of(context). size. width/3,
                          decoration: BoxDecoration(
                              color: Colors.green, borderRadius: BorderRadius.circular(10)),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
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
              )
              )
            ]
        )
    );
  }
}