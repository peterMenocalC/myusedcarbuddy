import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_mucb/utils/Colors.dart';
import 'package:image_picker/image_picker.dart';
import 'main.dart';
import 'dart:io';

// ignore: must_be_immutable

class InProgressInspectionDetails extends StatefulWidget {
  final name;
  InProgressInspectionDetails({
    Key key, @required this.name}) : super(key: key);
  @override
  InProgressState createState() => InProgressState();
}

class InProgressState extends State<InProgressInspectionDetails> {

  File image1, image2, image3, image4, image5, image6, image7, image8;
  /// Widget
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Inspection"),
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
                          padding: EdgeInsets.only(left: 10, bottom: 10, top:10),
                          child: Text("Inspection", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10, bottom: 10, top: 10),
                          child: Text("Status: In-Progress", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      height: 40,
                      width: MediaQuery. of(context). size. width/2,
                      decoration: BoxDecoration(
                          color: Colors.white, border: Border.all(
                        color: Colors.black,
                        width: 1,
                      )),
                      child: TextButton(
                        onPressed: () {
                          showDialog1(context);
                        },
                        child: Text(
                          'VEHICLE DETAILS',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      color: subHeaderBackground,
                      width: MediaQuery. of(context). size. width,
                      child: Center(
                        child: Text("General Required Images", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.white, border: Border.all(
                          color: Colors.black,
                          width: 1,
                        )),
                        child: Row(
                          children: <Widget>[
                            getGestureDetector1(context),
                            Padding(
                              padding: EdgeInsets.only(top: 10, left: 10),
                              child: Text("FRONT GLAMOR SHOT", style: TextStyle(fontSize: 16.0),),
                            ),
                          ],
                        ),
                      ),
                    ),

                Container( alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white, border: Border.all(
                    color: Colors.black,
                    width: 1,
                  )),
                  child: Row(
                      children: <Widget>[
                        getGestureDetector2(context),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("ODOMETER / MILEAGE", style: TextStyle(fontSize: 16),),
                        ),
                      ],
                    ),
                ),),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white, border: Border.all(
                    color: Colors.black,
                    width: 1,
                  )),
                  child:
                    Row(
                      children: <Widget>[
                        getGestureDetector3(context),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("STOCK NUMER", style: TextStyle(fontSize: 16),),
                        ),
                      ],
                    ),
                ),),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white, border: Border.all(
                    color: Colors.black,
                    width: 1,
                  )),
                  child: Row(
                      children: <Widget>[
                        getGestureDetector4(context),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("BOOKS & MANUAL", style: TextStyle(fontSize: 16),),
                        ),
                      ],
                    ),),),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white, border: Border.all(
                    color: Colors.black,
                    width: 1,
                  )),
                  child: Row(
                      children: <Widget>[
                        getGestureDetector5(context),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("VIN / LABEL", style: TextStyle(fontSize: 16),),
                        ),
                      ],
                    ),),),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white, border: Border.all(
                    color: Colors.black,
                    width: 1,
                  )),
                  child: Row(
                      children: <Widget>[
                        getGestureDetector6(context),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("TYRE DECAL", style: TextStyle(fontSize: 16),),
                        ),
                      ],
                    ),),),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white, border: Border.all(
                    color: Colors.black,
                    width: 1,
                  )),
                  child: Row(
                      children: <Widget>[
                        getGestureDetector7(context),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("EMISSIONS LABEL", style: TextStyle(fontSize: 16.0),),
                        ),
                      ],
                    ),),),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white, border: Border.all(
                    color: Colors.black,
                    width: 1,
                  )),
                  child:Row(
                      children: <Widget>[
                        getGestureDetector8(context),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text("KEYS", style: TextStyle(fontSize: 16),),
                        ),
                      ],
                    ),),),
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
                              'CANCEL',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, right: 30, bottom: 10),
                          height: 40,
                          width: MediaQuery. of(context). size. width/3,
                          decoration: BoxDecoration(
                              color: primaryColor, borderRadius: BorderRadius.circular(10)),
                          child: TextButton(
                            onPressed: () {
                             //
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

  Future showDialog1(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: appStore.scaffoldBackground,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)), //this right here
            child: Container(
                width:  MediaQuery. of(context). size. width,
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
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
                              Flexible(child: Padding(
                                padding: EdgeInsets.only(top: 10, left: 10),
                                child: Text("Larry Goodall", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                              ),)

                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width:  MediaQuery. of(context). size. width/3,
                                padding: EdgeInsets.only(top: 10),
                                child: Text("Contact Phone", style: TextStyle(fontSize: 14.0, ),textAlign: TextAlign.end,),
                              ),
                              Flexible(child: Padding(
                                padding: EdgeInsets.only(top: 10, left: 10),
                                child: Text("561-555-1299", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                              ),)

                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width:  MediaQuery. of(context). size. width/3,
                                padding: EdgeInsets.only(top: 10),
                                child: Text("Dealership", style: TextStyle(fontSize: 14.0, ),textAlign: TextAlign.end,),
                              ),
                              Flexible(child: Padding(
                                padding: EdgeInsets.only(top: 10, left: 10),
                                child: Text("Toyota of Orlando", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                              ),)

                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width:  MediaQuery. of(context). size. width/3,
                                padding: EdgeInsets.only(top: 10),
                                child: Text("Dealership Phone", style: TextStyle(fontSize: 14.0, ),textAlign: TextAlign.end,),
                              ),
                              Flexible(child: Padding(
                                padding: EdgeInsets.only(top: 10, left: 10),
                                child: Text("561-555-1299", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                              ),)
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width:  MediaQuery. of(context). size. width/3,
                                padding: EdgeInsets.only(top: 10),
                                child: Text("Location", style: TextStyle(fontSize: 14.0, ),textAlign: TextAlign.end,),
                              ),
                              Flexible(child: Padding(
                                padding: EdgeInsets.only(top: 10, left: 10),
                                child: Text("1495 NW 10st St, Orlando, FL 33417", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                              ),)
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width:  MediaQuery. of(context). size. width/3,
                                padding: EdgeInsets.only(top: 10),
                                child: Text("Buyer", style: TextStyle(fontSize: 14.0, ),textAlign: TextAlign.end,),
                              ),
                              Flexible(child: Padding(
                                padding: EdgeInsets.only(top: 10, left: 10),
                                child: Text("Michael Donovan", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                              ),)
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width:  MediaQuery. of(context). size. width/3,
                                padding: EdgeInsets.only(top: 10),
                                child: Text("Year", style: TextStyle(fontSize: 14.0, ),textAlign: TextAlign.end,),
                              ),
                              Flexible(child: Padding(
                                padding: EdgeInsets.only(top: 10, left: 10),
                                child: Text("2016", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                              ),)
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width:  MediaQuery. of(context). size. width/3,
                                padding: EdgeInsets.only(top: 10),
                                child: Text("Make", style: TextStyle(fontSize: 14.0, ),textAlign: TextAlign.end,),
                              ),
                              Flexible(child: Padding(
                                padding: EdgeInsets.only(top: 10, left: 10),
                                child: Text("Toyota", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                              ),)

                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width:  MediaQuery. of(context). size. width/3,
                                padding: EdgeInsets.only(top: 10),
                                child: Text("Model", style: TextStyle(fontSize: 14.0, ),textAlign: TextAlign.end,),
                              ),
                              Flexible(child: Padding(
                                padding: EdgeInsets.only(top: 10, left: 10),
                                child: Text("Camery", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                              ),)

                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                width:  MediaQuery. of(context). size. width/3,
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text("VIN", style: TextStyle(fontSize: 14.0, ),textAlign: TextAlign.end,),
                              ),
                              Flexible(child: Padding(
                                padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                                child: Text("A1XD29087JK2019", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                              ),)
                            ],
                          ),
                        ]

                    )
                )

            )
        );
      },
    );
  }

  getGestureDetector1(context) {
    return GestureDetector(
      onTap: () {
        _showPicker(context, 1);
      },
      child: image1 != null ? Container(
        width:  MediaQuery. of(context). size. width/3,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Image.file(
          image1,
          width: 100,
          height: 100,
          fit: BoxFit.fitHeight,
        ),
      ) : Container(
      width:  MediaQuery. of(context). size. width/3,
      padding: EdgeInsets.only(top: 10),
      child: const Icon(Icons.add_photo_alternate),
    ),
    );
  }

  /// Get from gallery
  _getFromGallery1() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      if (pickedFile != null) {
        image1 = File(pickedFile.path);
      }
    });

  }

  /// Get from Camera
  _getFromCamera1() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      if (pickedFile != null) {
        image1 = File(pickedFile.path);
      }
    });
  }

  getGestureDetector2(context) {
    return GestureDetector(
      onTap: () {
        _showPicker(context, 2);
      },
      child: image2 != null ?Container(
        width:  MediaQuery. of(context). size. width/3,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Image.file(
          image2,
          width: 100,
          height: 100,
          fit: BoxFit.fitHeight,
        ),
      ) : Container(
        width:  MediaQuery. of(context). size. width/3,
        padding: EdgeInsets.only(top: 10),
        child: const Icon(Icons.add_photo_alternate),
      ),
    );
  }

  /// Get from gallery
  _getFromGallery2() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      if (pickedFile != null) {
        image2 = File(pickedFile.path);
      }
    });

  }

  /// Get from Camera
  _getFromCamera2() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      if (pickedFile != null) {
        image2 = File(pickedFile.path);
      }
    });
  }

  getGestureDetector3(context) {
    return GestureDetector(
      onTap: () {
        _showPicker(context, 3);
      },
      child: image3 != null ? Container(
        width:  MediaQuery. of(context). size. width/3,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Image.file(
          image3,
          width: 100,
          height: 100,
          fit: BoxFit.fitHeight,
        ),
      ) : Container(
        width:  MediaQuery. of(context). size. width/3,
        padding: EdgeInsets.only(top: 10),
        child: const Icon(Icons.add_photo_alternate),
      ),
    );
  }

  /// Get from gallery
  _getFromGallery3() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      if (pickedFile != null) {
        image3 = File(pickedFile.path);
      }
    });

  }

  /// Get from Camera
  _getFromCamera3() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      if (pickedFile != null) {
        image3 = File(pickedFile.path);
      }
    });
  }

  getGestureDetector4(context) {
    return GestureDetector(
      onTap: () {
        _showPicker(context, 4);
      },
      child: image4 != null ? Container(
        width:  MediaQuery. of(context). size. width/3,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Image.file(
          image4,
          width: 100,
          height: 100,
          fit: BoxFit.fitHeight,
        ),
      ) : Container(
        width:  MediaQuery. of(context). size. width/3,
        padding: EdgeInsets.only(top: 10),
        child: const Icon(Icons.add_photo_alternate),
      ),
    );
  }

  /// Get from gallery
  _getFromGallery4() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      if (pickedFile != null) {
        image4 = File(pickedFile.path);
      }
    });

  }

  /// Get from Camera
  _getFromCamera4() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      if (pickedFile != null) {
        image4 = File(pickedFile.path);
      }
    });
  }

  getGestureDetector5(context) {
    return GestureDetector(
      onTap: () {
        _showPicker(context, 5);
      },
      child: image5 != null ? Container(
        width:  MediaQuery. of(context). size. width/3,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Image.file(
          image5,
          width: 100,
          height: 100,
          fit: BoxFit.fitHeight,
        ),
      ) : Container(
        width:  MediaQuery. of(context). size. width/3,
        padding: EdgeInsets.only(top: 10),
        child: const Icon(Icons.add_photo_alternate),
      ),
    );
  }

  /// Get from gallery
  _getFromGallery5() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      if (pickedFile != null) {
        image5 = File(pickedFile.path);
      }
    });

  }

  /// Get from Camera
  _getFromCamera5() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      if (pickedFile != null) {
        image5 = File(pickedFile.path);
      }
    });
  }

  getGestureDetector6(context) {
    return GestureDetector(
      onTap: () {
        _showPicker(context, 6);
      },
      child: image6 != null ? Container(
        width:  MediaQuery. of(context). size. width/3,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Image.file(
          image6,
          width: 100,
          height: 100,
          fit: BoxFit.fitHeight,
        ),
      ) : Container(
        width:  MediaQuery. of(context). size. width/3,
        padding: EdgeInsets.only(top: 10),
        child: const Icon(Icons.add_photo_alternate),
      ),
    );
  }

  /// Get from gallery
  _getFromGallery6() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      if (pickedFile != null) {
        image6 = File(pickedFile.path);
      }
    });

  }

  /// Get from Camera
  _getFromCamera6() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      if (pickedFile != null) {
        image6 = File(pickedFile.path);
      }
    });
  }

  getGestureDetector7(context) {
    return GestureDetector(
      onTap: () {
        _showPicker(context, 7);
      },
      child: image7 != null ? Container(
        width:  MediaQuery. of(context). size. width/3,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Image.file(
          image7,
          width: 100,
          height: 100,
          fit: BoxFit.fitHeight,
        ),
      ) : Container(
        width:  MediaQuery. of(context). size. width/3,
        padding: EdgeInsets.only(top: 10),
        child: const Icon(Icons.add_photo_alternate),
      ),
    );
  }

  /// Get from gallery
  _getFromGallery7() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      if (pickedFile != null) {
        image7 = File(pickedFile.path);
      }
    });

  }

  /// Get from Camera
  _getFromCamera7() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      if (pickedFile != null) {
        image7 = File(pickedFile.path);
      }
    });
  }

  getGestureDetector8(context) {
    return GestureDetector(
      onTap: () {
        _showPicker(context, 8);
      },
      child: image8 != null ? Container(
        width:  MediaQuery. of(context). size. width/3,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Image.file(
          image8,
          width: 100,
          height: 100,
          fit: BoxFit.fitHeight,
        ),
      ) : Container(
        width:  MediaQuery. of(context). size. width/3,
        padding: EdgeInsets.only(top: 10),
        child: const Icon(Icons.add_photo_alternate),
      ),
    );
  }

  /// Get from gallery
  _getFromGallery8() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      if (pickedFile != null) {
        image8 = File(pickedFile.path);
      }
    });

  }

  /// Get from Camera
  _getFromCamera8() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      if (pickedFile != null) {
        image8 = File(pickedFile.path);
      }
    });
  }

  void _showPicker(context, position) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        if (position == 1) {
                          _getFromGallery1();
                        } else if (position == 2) {
                          _getFromGallery2();
                        } else if (position == 3) {
                          _getFromGallery3();
                        } else if (position == 4) {
                          _getFromGallery4();
                        } else if (position == 5) {
                          _getFromGallery5();
                        } else if (position == 6) {
                          _getFromGallery6();
                        } else if (position == 7) {
                          _getFromGallery7();
                        } else if (position == 8) {
                          _getFromGallery8();
                        }
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      if (position == 1) {
                        _getFromCamera1();
                      } else if (position == 2) {
                        _getFromCamera2();
                      } else if (position == 3) {
                        _getFromCamera3();
                      } else if (position == 4) {
                        _getFromCamera4();
                      } else if (position == 5) {
                        _getFromCamera5();
                      } else if (position == 6) {
                        _getFromCamera6();
                      } else if (position == 7) {
                        _getFromCamera7();
                      } else if (position == 8) {
                        _getFromCamera8();
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

}