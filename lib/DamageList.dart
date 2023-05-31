import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_mucb/NewDamageEntry.dart';
import 'package:flutter_app_mucb/model/InspectionOptionsData.dart';
import 'package:flutter_app_mucb/model/PostInspectionOptionsData.dart';
import 'package:flutter_app_mucb/utils/Colors.dart';
import 'package:focus_detector/focus_detector.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loading_gifs/loading_gifs.dart';
import 'package:nb_utils/nb_utils.dart';

import 'ErrorView.dart';
import 'NoInternetConnection.dart';

class DamageList extends StatefulWidget {
  final categoryId;
  final userId;
  final orderId;
  final subCategoryId;
  final name;
  final questionId;


  DamageList(
      {Key key, @required this.userId, @required this.categoryId, @required this.orderId, @required this.subCategoryId, @required this.name, @required this.questionId})
      : super(key: key);

  @override
  _DamageListState createState() => _DamageListState();
}
class _DamageListState extends State<DamageList> implements DeleteEntryCallback{
  final ScrollController scrollController = ScrollController();
  bool mIsLoading = false;
  List<Damage>damages = new List();

 @override
  void initState() {
    super.initState();
   // getInspectionOrderDetails();
  }

  Future<void> getInspectionOrderDetails() async {
    setState(() {
      mIsLoading = true;
    });
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await getDamageListData(
            widget.userId, widget.orderId, widget.categoryId,
            widget.subCategoryId, widget.questionId)
            .then((res) async {
          mIsLoading = false;
          setState(() {
            List <Question> questions = res.questions;
            for (int i = 0; i < questions.length; i++) {
              Question question = questions[i];
              log("<<<<<<>>>" + question.id.toString() + "<<<" +
                  widget.questionId);
              if (question.id.toString() == widget.questionId) {
                log("<<< image url" + question.id.toString() +"<<"+ widget.questionId);
                damages.addAll(question.saved_damaged_options);
                return;
              }
            }
          });
        }).catchError((onError) {
          setState(() {
            mIsLoading = false;
          });
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

  Future<InspectionOptionsData> getDamageListData(String userId, String orderId,
      String categoryId, String subCategoryId, String questionId) async {
   log("user_id" + userId +" category_id" + categoryId + " order_id" + orderId +" sub_category_id"+subCategoryId);
    final response = await http.post(
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'user_id': userId,
        'category_id': categoryId,
        'order_id': orderId,
        'sub_category_id': subCategoryId
      }),
    );
    log('data1: ' + 'after api call');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      log('data1: ' + response.body);
      return InspectionOptionsData.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      log('data1: ' + 'exception');

      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
        onFocusGained: () {
          damages.clear();
          getInspectionOrderDetails();
        },
        child: new Scaffold(
            appBar: AppBar(
              title: Text(widget.name),
                actions: <Widget>[
                  TextButton(
                    onPressed: _openAddEntryDialog,
                    child: Text('Add Damage', style: TextStyle(color: Colors.white,decoration: TextDecoration.underline),),
                  )
                ]
            ),
            body: new Stack(
              children: [
                Column(children: [
                  Expanded(
                      child: Scrollbar(
                          isAlwaysShown: true,
                          controller: scrollController,
                          child: ListView(
                              padding: EdgeInsets.all(8.0),
                              physics: const ScrollPhysics(),
                              children: List.generate(
                                  damages.length, (index) {
                                return SelectCard(
                                  report: damages[index],
                                  userId: widget.userId,
                                  questionId: widget.questionId,
                                  orderId: widget.orderId,
                                  callback: this,
                                );
                              }).toList()))),
                ]),
                mIsLoading
                    ? Container(
                  child: CircularProgressIndicator(),
                  alignment: Alignment.center,
                )
                    : SizedBox(),
              ],
            ),
            /*floatingActionButton: new FloatingActionButton(
              onPressed: _openAddEntryDialog,
              tooltip: 'Add new damage entry',
              child: new Icon(Icons.add),
            )*/));
  }

  Future _openAddEntryDialog() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                NewDamageEntry(
                  userId: widget.userId,
                  questionId: widget.questionId,
                  orderId: widget.orderId,
                  damageTypeId: 0,
                  damageSizeId: 0,
                  notes: "",
                  imageList: [],
                  damageId: "",
                )));
  }

  @override
  void valueUpdated(String msg) {
    damages.clear();
    getInspectionOrderDetails();
  }

}

class SelectCard extends StatelessWidget {
  const SelectCard(
      {Key key, this.report, @required this.userId, @required this.questionId, @required this.orderId, @required this.callback})
      : super(key: key);
  final Damage report;
  final userId;
  final questionId;
  final orderId;
  final DeleteEntryCallback callback;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: InkWell(
            onTap: () {
              //performStartInspection(context);
            },
            child: 
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child:
                  Padding(
                    padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        //width: MediaQuery.of(context).size.width / 3,
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Type",
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text(
                            report.type[0]!= null
                                ? report.type[0].title
                                : "NA",
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        //width: MediaQuery.of(context).size.width / 3,
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Size",
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text(
                            report.size[0]!= null
                                ? report.size[0].title
                                : "NA",
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                       // width: MediaQuery.of(context).size.width / 3,
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Notes",
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text(
                            report.notes!= null && report.notes.isNotEmpty
                                ? report.notes
                                : "NA",
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                  Visibility(
                    visible: report.images.isNotEmpty,
                    child: Container(
                        margin: EdgeInsets.only(top: 0),
                        height: 60,
                        child: ListView(
                            padding: EdgeInsets.all(2.0),
                            scrollDirection: Axis.horizontal,
                            physics: const ScrollPhysics(),
                            children: List.generate(report.images.length, (index) {
                              return ImagePost(report.images[index]);
                            }).toList())),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Visibility(
                            visible: true,
                            child: Container(
                              margin: EdgeInsets.only(top: 10, right: 30, bottom: 10),
                              height: 40,
                              width: MediaQuery.of(context).size.width / 3,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextButton(
                                onPressed: () {
                                  _deleteDamageEntry(context).then((value) async {
                                    callback.valueUpdated("success");
                                  }).catchError((onError) {

                                    ErrorView(
                                      message: onError.toString(),
                                    ).launch(context);
                                  });
                                },
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            )),
                        Visibility(
                            visible: true,
                            child: Container(
                              margin: EdgeInsets.only(top: 10, left: 30, bottom: 10),
                              height: 40,
                              width: MediaQuery.of(context).size.width / 3,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextButton(
                                onPressed: () {
                                  _openEditEntryDialog(context);
                                },
                                child: Text(
                                  'Edit',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            )),

                      ],
                    ),
                  )
                ],
              ),
                  )
            )));
  }
  Future _openEditEntryDialog(BuildContext context) async {
    log("<<size" +
         report.size[0].id.toString()
        );
    log("<<type" +
        report.type[0].id.toString()
    );
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                NewDamageEntry(
                  userId: userId,
                  questionId: questionId,
                  orderId: orderId,
                  damageTypeId:report.type[0]!= null
                      ? report.type[0].id
                      : 0 ,
                  damageSizeId: report.size[0]!= null
                      ? report.size[0].id
                      : 0,
                  notes: report.notes!= null && report.notes.isNotEmpty
                      ? report.notes
                      : "NA",
                  imageList: report.images,
                  damageId: report.id.toString(),
                )));
  }

  Future<InspectionPostResponse> _deleteDamageEntry(BuildContext context) async {
    log("<<size" +
        report.size[0].id.toString()
    );
    log("<<type" +
        report.type[0].id.toString()
    );

    final response = await http.post(
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'saved_damage_id': report.id,

      }),
    );
    log('data1: ' + 'after api call');

    if (response.statusCode == 200) {
      log('data1: ' + response.body);
      return InspectionPostResponse.fromJson(json.decode(response.body));
    } else {
      log('data1: ' + 'exception');

      throw Exception('Failed to load data');
    }
  }
}

class ImagePost extends StatefulWidget {
  final Images postData;

  ImagePost(Images data)
      : postData = data,
        super(key: new ObjectKey(data));

  @override
  ImagePostState createState() {
    return new ImagePostState(postData);
  }
}

class ImagePostState extends State<ImagePost> {
  final Images postData;

  ImagePostState(this.postData);

  @override
  Widget build(BuildContext context) {
    return getWidget(postData);
  }

  // ignore: missing_return
  Widget getWidget(Images postData) {
    return imageView(data: postData);
  }

  Widget imageView({Images data}) {
    return Container(
      width: 70,
      padding: EdgeInsets.all(3),
      child: File(data.image).existsSync()
          ? Image.file(
        File(data.image),
        height: 40,
        width: 40,
      )
          : FadeInImage.assetNetwork(
          placeholder: cupertinoActivityIndicator,
          image: data.image,
          height: 40,
          width: 40,
          placeholderScale: 5),
    );
  }
}
abstract class DeleteEntryCallback {
  void valueUpdated(String msg);
}