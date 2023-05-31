import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_mucb/DamageList.dart';
import 'package:flutter_app_mucb/InspectionVehicleDetails.dart';
import 'package:flutter_app_mucb/SharedPreferencesHelper.dart';
import 'package:flutter_app_mucb/model/InspectionOptionsData.dart';
import 'package:flutter_app_mucb/model/InspectionRequestListData.dart';
import 'package:flutter_app_mucb/model/PostInspectionOptionsData.dart';
import 'package:flutter_app_mucb/model/StartInspectionData.dart';
import 'package:flutter_app_mucb/navigationDrawerCategory.dart';
import 'package:flutter_app_mucb/utils/Colors.dart';
import 'package:flutter_app_mucb/utils/FixedOffsetTextEditingController.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http_parser/http_parser.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import 'ErrorView.dart';
import 'NoInternetConnection.dart';
import 'Widget/FailDialog.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:io';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'model/DamageEntry.dart';

class StartInspection extends StatefulWidget {
  final name;
  final userId;
  final List<Category> categories;
  final int position;
  final int subCategoryPosition;
  final orderId;
  final InspectionRequestListData vehicleData;

  StartInspection(
      {Key key,
      @required this.name,
      @required this.orderId,
      @required this.userId,
      @required this.categories,
      @required this.position,
      @required this.subCategoryPosition,
      this.vehicleData})
      : super(key: key);

  @override
  _StartInspectionState createState() => _StartInspectionState();
}

class _StartInspectionState extends State<StartInspection>
    implements AlertDialogCallback {
  bool prevVisible = true;
  bool nextVisible = true;
  bool finishVisible = true;
  bool mIsLoading = false;
  bool isFinishButtonEnabled = false;
  List<Question> questionsData = List();
  List<QuestionAnswer> answers = List();
  final ScrollController scrollController = ScrollController();
  List<ImagePostData> imageDataList = List();
  List<Question> serverQuestionData = List();
  String defaultImage ="";
  List<int> excludeValuesQuestionId = List();
  @override
  void initState() {
    excludeValuesQuestionId.add(421);
    excludeValuesQuestionId.add(423);
    excludeValuesQuestionId.add(428);
    excludeValuesQuestionId.add(430);
    excludeValuesQuestionId.add(443);
    excludeValuesQuestionId.add(445);
    excludeValuesQuestionId.add(436);
    excludeValuesQuestionId.add(438);
    
    updateFinishStatus();
    getInspectionOrderDetails();
  }

  Future<void> updateFinishStatus() async {
    SharedPreferencesHelper.isAllDataFilled(widget.orderId).then((value) => {
      setState((){
        isFinishButtonEnabled = value;
      })
    });
  }

  Future<void> getInspectionOrderDetails() async {
    Category category = widget.categories[widget.position];
    SubCategory subCategory =
        category.sub_categories[widget.subCategoryPosition];
    setState(() {
      mIsLoading = true;
    });
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await getQuestions(
                widget.userId, widget.orderId, category.id, subCategory.id)
            .then((res) async {
          mIsLoading = false;
          setState(() {
            defaultImage=res.defaultImage;
            serverQuestionData.addAll(res.questions);
            questionsData.addAll(res.questions);
            for (int i = 0; i < serverQuestionData.length; i++) {
              Question question = serverQuestionData[i];
              if (question.options.isNotEmpty) {
                buildSubQuestions(question.options, question.id, question.input_var);
              }
              int position = -1;
              if (question.associated_questions != null &&
                  question.associated_questions.isNotEmpty) {
                for (int i = 0; i < questionsData.length; i++) {
                  Question ques = questionsData[i];
                  if (ques.id == question.id) {
                    position = i;
                    break;
                  }
                }
                for (int i = 0; i < question.associated_questions.length; i++) {
                  Question ques = question.associated_questions[i];
                  ques.parentId2 = question.id;
                }
                questionsData.insertAll(position + 1, question.associated_questions);
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

  void buildSubQuestions(List<Option> options, int parentId, String selectedOption) {
    for (int j = 0; j < options.length; j++) {
      Option option = options[j];
      if (option.associated_questions.isNotEmpty && selectedOption == option.id.toString()) {
        for (int k = 0; k < option.associated_questions.length; k++) {
          Question que = option.associated_questions[k];
          que.parentId = parentId;
            for (int i = 0; i < questionsData.length; i++) {
              Question question = questionsData[i];
              if(question.id == que.parentId){
                questionsData.insert(i + 1, que);
                if (que.options.isNotEmpty) {
                  buildSubQuestions(que.options, que.id, que.input_var);
                }
                break;
              }

          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Category category = widget.categories[widget.position];
    SubCategory subCategory =
        category.sub_categories[widget.subCategoryPosition];
    if (widget.position <= 0 && widget.subCategoryPosition <= 0) {
      hidePrev();
    } else {
      showPrev();
    }

    if (widget.position >= widget.categories.length - 1 &&
        widget.subCategoryPosition >= category.sub_categories.length - 1) {
      showFinish();
    } else {
      hideFinish();
    }

    return new Scaffold(
      appBar: AppBar(
          title: Text(category.title + ":" + subCategory.title,
              style: TextStyle(fontSize: 14)),
          backgroundColor: primaryColor,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    showVehicleDetailsDialog(context);
                  },
                  child: Icon(
                    Icons.car_repair,
                    size: 26.0,
                  ),
                ))
          ]),
      drawer: navigationDrawerCategory(
        list: widget.categories,
        userid: widget.userId,
        orderid: widget.orderId,
        vehicleData: widget.vehicleData,
      ),
      body: new Stack(
        children: [
          Column(children: [
            Expanded(
                child: Scrollbar(
                    isAlwaysShown: true,
                    controller: scrollController,
                    child: ListView(
                        padding: EdgeInsets.all(2.0),
                        physics: const ScrollPhysics(),
                        children: List.generate(questionsData.length, (index) {
                          return InspectionChild(
                              questionsData[index],
                              index,
                              this,
                              widget.orderId,
                              widget.userId,
                              category.id.toString(),
                              subCategory.id.toString(),
                          defaultImage);
                        }).toList()))),
            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Visibility(
                      visible: prevVisible,
                      child: Container(
                        margin: EdgeInsets.only(top: 10, left: 30, bottom: 10),
                        height: 40,
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                          onPressed: () {
                              if (widget.subCategoryPosition - 1 >= 0) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => StartInspection(
                                              categories: widget.categories,
                                              position: widget.position,
                                              subCategoryPosition:
                                                  widget.subCategoryPosition -
                                                      1,
                                              orderId: widget.orderId,
                                              userId: widget.userId,
                                              vehicleData: widget.vehicleData,
                                            )));
                              } else {
                                int postion = widget.position - 1;
                                Category prevCategory =
                                    widget.categories[postion];
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => StartInspection(
                                              categories: widget.categories,
                                              position: widget.position - 1,
                                              subCategoryPosition: prevCategory
                                                      .sub_categories.length -
                                                  1,
                                              userId: widget.userId,
                                              orderId: widget.orderId,
                                              vehicleData: widget.vehicleData,
                                            )));
                              }
                          },
                          child: Text(
                            'Prev',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      )),
                  Visibility(
                      visible: true,
                      child: Container(
                        margin: EdgeInsets.only(top: 10, right: 30, bottom: 10),
                        height: 40,
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                          onPressed: () {
                            bool isComplete = true;
                            String questionTitle;
                            for (int i = 0; i < answers.length; i++) {
                              QuestionAnswer questionAnswer = answers[i];
                              if(questionAnswer.isComplete == false)
                              {

                                for (int i = 0; i < serverQuestionData.length; i++) {
                                  Question qusetion = serverQuestionData[i];
                                  if(qusetion.id == questionAnswer.question_id)
                                    {
                                      questionTitle = qusetion.title;
                                      break;
                                    }
                                }
                                isComplete = false;
                                break;
                              }
                            }
                            if(isComplete) {
                              bool allDataAdded = allDataFilled();
                              SubCategory subCategory =
                              category.sub_categories[widget
                                  .subCategoryPosition];
                              SharedPreferencesHelper
                                  .setSubCategoryIdStatusCompleted(
                                  widget.orderId, subCategory.id.toString(),
                                  allDataAdded).then((value) => {
                                    updateFinishStatus(),
                              if (finishVisible || allDataAdded) {
                                  handleNextClicked()
                            } else {
                              showConfirmationDialog(context)
                            }
                              } );

                            }
                            else{
                              Fluttertoast.showToast(
                                  msg: "Please fill data required for " + questionTitle,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          child: Text(
                            finishVisible ? 'Save' : 'Next',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ))
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Visibility(
                  visible: finishVisible,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    height: 40,
                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: !isFinishButtonEnabled ? (){
                        Fluttertoast.showToast(
                            msg: "Please fill all data to finish inspection",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);

                      } : (){
                        setState(() {
                          mIsLoading = true;
                        });
                        doFinish();
                      },
                      child: Text(
                        'Finish',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  )),
            )
          ]),
          mIsLoading
              ? Container(
                  child: CircularProgressIndicator(),
                  alignment: Alignment.center,
                )
              : SizedBox(),
        ],
      ),
    );
  }

  void showFinish() {
    setState(() {
      finishVisible = true;
    });
  }

  void hideFinish() {
    setState(() {
      finishVisible = false;
    });
  }

  void showPrev() {
    setState(() {
      prevVisible = true;
    });
  }

  void hidePrev() {
    setState(() {
      prevVisible = false;
    });
  }

  Future showConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: appStore.scaffoldBackground,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)), //this right here
            child: Container(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "You have not filled all details. Are you still want to visit next page ?",
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            height: 40,
                            width: MediaQuery.of(context).size.width / 4,
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'No',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            height: 40,
                            width: MediaQuery.of(context).size.width / 4,
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10)),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                handleNextClicked();
                              },
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ]))));
      },
    );
  }

  Future showVehicleDetailsDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: appStore.scaffoldBackground,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)), //this right here
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        color: subHeaderBackground,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text("Vehicle Details",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
                        ),
                      ),
                          Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Order",
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
                                    widget.orderId != null
                                        ? widget.orderId.toString()
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
                            width: MediaQuery.of(context).size.width / 3,
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Contact",
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
                                widget.vehicleData.salesPerson != null
                                    ? widget.vehicleData.salesPerson
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
                            width: MediaQuery.of(context).size.width / 3,
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Contact Phone",
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
                                widget.vehicleData.salesPersonPhone != null
                                    ? widget.vehicleData.salesPersonPhone
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
                            width: MediaQuery.of(context).size.width / 3,
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Dealership",
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
                                widget.vehicleData.seller != null
                                    ? widget.vehicleData.seller
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
                            width: MediaQuery.of(context).size.width / 3,
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Dealership Phone",
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
                                "NA",
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
                            width: MediaQuery.of(context).size.width / 3,
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Location",
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Flexible(
                              child:InkWell(
                                  onTap: () {
                                    log('In tap button');
                                    MapsLauncher.launchQuery(
                                        widget.vehicleData.location != null
                                            ? widget.vehicleData.location
                                            : "");
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10, left: 10),
                                    child: new Text(widget.vehicleData.location != null
                                        ? widget.vehicleData.location
                                        : "NA",
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,decoration: TextDecoration.underline),
                                  )
                              ),
                            /*child: Padding(
                              padding: EdgeInsets.only(top: 10, left: 10),
                              child: Text(
                                widget.vehicleData.location != null
                                    ? widget.vehicleData.location
                                    : "NA",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),*/
                          )
                          )],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Buyer",
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
                                widget.vehicleData.buyer != null
                                    ? widget.vehicleData.buyer
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
                            width: MediaQuery.of(context).size.width / 3,
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Year",
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
                                widget.vehicleData.carYear != null
                                    ? widget.vehicleData.carYear
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
                            width: MediaQuery.of(context).size.width / 3,
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Make",
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
                                widget.vehicleData.carMake != null
                                    ? widget.vehicleData.carMake
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
                            width: MediaQuery.of(context).size.width / 3,
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Model",
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
                                widget.vehicleData.carModel != null
                                    ? widget.vehicleData.carModel
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
                            width: MediaQuery.of(context).size.width / 3,
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              "VIN",
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 10, left: 10, bottom: 10),
                              child: Text(
                                widget.vehicleData.vehicleVin != null
                                    ? widget.vehicleData.vehicleVin.trim()
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
                                width: MediaQuery.of(context).size.width / 3,
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "Customer Notes",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 10, left: 10, bottom: 10),
                                  child: Text(
                                    widget.vehicleData.customerNotes != null && widget.vehicleData.customerNotes.isNotEmpty
                                        ? widget.vehicleData.customerNotes
                                        : "NA",
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                    ]))));
      },
    );
  }

  @override
  void valueUpdatedText(int questionId, String answer) {
    setState(() {
      answers.add(new QuestionAnswer(question_id: questionId, answer: answer));
    });
  }

  @override
  void valueUpdatedTextWithNoSetState(int questionId, String answer) {
    answers.add(new QuestionAnswer(question_id: questionId, answer: answer));
  }

  @override
  void valueUpdatedCheckBox(
      Option option, int questionId, bool value, Question question) {
    setState(() {
      if (value) {
        List<String> list = List();
        for (int i = 0; i < answers.length; i++) {
          QuestionAnswer questionAnswer = answers[i];
          if (questionAnswer.question_id == questionId) {
            answers.removeAt(i);
          }
        }
        if (!question.input_var.isEmptyOrNull) {
          list.addAll(question.input_var.split(","));
        }
        list.add(option.id.toString());
        String answer = list.join(",");
        question.input_var = answer;
        String questionValue = question.value;
        List<String> valueList = List();
        if (questionValue.isEmptyOrNull) {
           valueList.add(option.title);
        } else {
          valueList.addAll(questionValue.split(","));
          valueList.add(option.title);
        }
        question.value =  valueList.join(",");
        answers
            .add(new QuestionAnswer(question_id: questionId, answer: answer));
        if(question.associated_tire_qns.length > 1 ) {
          for(int i =0 ; i < question.associated_tire_qns.length ;i++) {
            for(int j =0 ; j < questionsData.length ;j++) {
              if(questionsData[j].parentId2 == questionId){
                for(int k =0 ; k < questionsData.length ;k++) {
                   if(questionsData[k].parentId2 == question.associated_tire_qns[i]) {
                     if(questionsData[k].title == questionsData[j].title && !excludeValuesQuestionId.contains(questionsData[k].id)) {
                       if(questionsData[k].option_type == "radio" || questionsData[k].option_type == "checkbox"){
                         questionsData[k].value = questionsData[j].value;
                         if(!questionsData[k].value.isEmptyOrNull){
                           List<String> valueList = questionsData[k].value.split(",");
                           List<String> inputVarList = List();
                           if(questionsData[k].options!=null &&  questionsData[k].options.isNotEmpty){
                             for(int m = 0; m < questionsData[k].options.length; m++) {
                               Option option = questionsData[k].options[m];
                               if(valueList.contains(option.title)){
                                 inputVarList.add(option.id.toString());
                               }
                             }
                             if(inputVarList.isNotEmpty){
                               questionsData[k].input_var = inputVarList.join(",");
                             } else {
                               questionsData[k].input_var = "";
                             }
                           } else {
                             questionsData[k].input_var = "";
                           }
                         }
                       } else {
                         questionsData[k].input_var = questionsData[j].input_var;

                       }
                       for (int l = 0; l < answers.length; l++) {
                         QuestionAnswer questionAnswer = answers[l];
                         if (questionAnswer.question_id == questionsData[k].id) {
                           if (questionAnswer.answer.isNotEmpty) {
                             answers.removeAt(l);
                           }
                         }
                       }
                       answers.add(new QuestionAnswer(question_id: questionsData[k].id, answer:  questionsData[k].input_var));
                     }
                   }
                }
              }
            }
          }
        } else if(question.associated_tire_qns.length == 1) {
          int tireAssociatedId = question.associated_tire_qns[0];
            for(int j =0 ; j < questionsData.length ;j++) {
              if(questionsData[j].parentId2 == tireAssociatedId){
                for(int k =0 ; k < questionsData.length ;k++) {
                  if(questionsData[k].parentId2 == questionId){
                    if(questionsData[k].title == questionsData[j].title && !excludeValuesQuestionId.contains(questionsData[k].id)){
                      if(questionsData[k].option_type == "radio" || questionsData[k].option_type == "checkbox"){
                        questionsData[k].value = questionsData[j].value;
                        if(!questionsData[k].value.isEmptyOrNull){
                          List<String> valueList = questionsData[k].value.split(",");
                          List<String> inputVarList = List();
                          if(questionsData[k].options!=null &&  questionsData[k].options.isNotEmpty){
                            for(int m = 0; m < questionsData[k].options.length; m++) {
                              Option option = questionsData[k].options[m];
                              if(valueList.contains(option.title)){
                                inputVarList.add(option.id.toString());
                              }
                            }
                            if(inputVarList.isNotEmpty){
                              questionsData[k].input_var = inputVarList.join(",");
                            } else {
                              questionsData[k].input_var = "";
                            }
                          } else {
                            questionsData[k].input_var = "";
                          }
                        }
                      } else {
                        questionsData[k].input_var = questionsData[j].input_var;
                      }
                      for (int l = 0; l < answers.length; l++) {
                        QuestionAnswer questionAnswer = answers[l];
                        if (questionAnswer.question_id == questionsData[k].id) {
                          if (questionAnswer.answer.isNotEmpty) {
                            answers.removeAt(l);
                          }
                        }
                      }
                      answers.add(new QuestionAnswer(question_id: questionsData[k].id, answer:  questionsData[k].input_var));
                    }
                  }
                }
              }
            }
        }
      } else {
        List<String> list = List();
        for (int i = 0; i < answers.length; i++) {
          QuestionAnswer questionAnswer = answers[i];
          if (questionAnswer.question_id == questionId) {
            answers.removeAt(i);
          }
        }
        if (!question.input_var.isEmptyOrNull) {
          list.addAll(question.input_var.split(","));
        }
        list.remove(option.id.toString());
        String answer = "";
        if (list.isNotEmpty) {
          answer = list.join(",");
        }
        question.input_var = answer;

        String questionValue = question.value;
        List<String> valueList = List();
        if (questionValue.isNotEmpty) {
          valueList.addAll(questionValue.split(","));
          if(valueList.contains(option.title)){
            valueList.remove(option.title);
          }
        }
        question.value =  valueList.join(",");
        answers.add(new QuestionAnswer(question_id: questionId, answer: answer));
      }
    });
  }

  @override
  void valueUpdatedRadio(Option option, int parentIndex, Question data, bool failPopupStatus,String categoryId, String subCategoryId) {
    setState(() {
      for (int i = 0; i < answers.length; i++) {
        QuestionAnswer questionAnswer = answers[i];
        if (questionAnswer.question_id == parentIndex) {
          answers.removeAt(i);
        }
      }
      answers.add(new QuestionAnswer(
          question_id: parentIndex, answer: option.id.toString()));
      List<int> list = List();
      performRemoval(parentIndex, list);
      if (list.isNotEmpty) {
        for (int i = 0; i < list.length; i++) {
          int position = list[i];
          for (int i = 0; i < questionsData.length; i++) {
            Question child = questionsData[i];
            if (child.id == position) {
              questionsData.removeAt(i);
            }
          }
        }
      }
      if (option.associated_questions != null &&
          option.associated_questions.isNotEmpty) {
        int parentPosition = -1;
        for (int i = 0; i < questionsData.length; i++) {
          Question child = questionsData[i];
          if (child.id == parentIndex) {
            parentPosition = i;
          }
        }
        for (int j = 0; j < option.associated_questions.length; j++) {
          Question child = option.associated_questions[j];
          questionsData.insert(parentPosition + 1, child);

        }
      }
      if (option.title.toString() == "Fail") {
        if (failPopupStatus)
          {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return new FailDialog(
                  callback: this,
                  question: data,
                  orderId: widget.orderId,
                  parentIndex: parentIndex,
                  userId: widget.userId,
                  categoryId: categoryId,
                  subCategoryId: subCategoryId,
                 // callback: this,
                  // ignore: missing_return
                );
              });
      }
        else{
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return new MyCameraDialog(
                  callback: this,
                  question: data,
                  orderId: widget.orderId,
                  parentIndex: parentIndex,
                 // userId: widget.userId,
                  // ignore: missing_return
                );
              });
        }
      }
    });
  }

  void performRemoval(int parentIndex, List<int> list) {
    for (int i = 0; i < questionsData.length; i++) {
      Question child = questionsData[i];
      if (child.parentId == parentIndex) {
        list.add(child.id);
        performRemoval(child.id, list);
        child.input_var = null;
        child.value = null;
        answers.add(new QuestionAnswer(question_id: child.id, answer: ""));
        log("removed at $i");
      }
    }
  }

  @override
  void valueUpdateImage(ImagePostData postData) {
    imageDataList.add(postData);
    uploadImage(postData);
  }

  @override
  Future<void> uploadOptionalImages(List<ImagePostData> list) async {
    if (list.isEmpty) {
      return;
    }
    setState(() {
      mIsLoading = true;
    });
    var uri =
    var request = new http.MultipartRequest("POST", uri);
    for (int i = 0; i < list.length; i++) {
      ImagePostData postData = list[i];
      File file = File(postData.filePath);
      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
      var length = await file.length();
      var multipartFile = new http.MultipartFile(
          postData.fileName, stream, length,
          filename: postData.fileName, contentType: MediaType("image", "jpeg"));
      request.files.add(multipartFile);
    }
    var response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        mIsLoading = false;
      });
    } else {
      setState(() {
        mIsLoading = false;
      });
    }
  }

  @override
  bool checkTitle(String title) {
    bool status = false;
    serverQuestionData.forEach((Question question) {
      if (question.title == title) {
        status = true;
        return;
      }
    });
    return status;
  }

  @override
  void updateValueForComment(int questionId, String comment, int parentIndex , bool isComplete) {
    setState(() {
      for (int i = 0; i < answers.length; i++) {
        QuestionAnswer questionAnswer = answers[i];
        if (questionAnswer.question_id == parentIndex) {
          answers[i].optional_message = comment;
          answers[i].isComplete = isComplete;
          log(answers[i].answer + answers[i].optional_message + answers[i].question_id.toString());
        }
      }
     // answers.add(new QuestionAnswer(question_id: questionId, optional_message: comment));
    });
  }

  @override
  void valueUpdatedForFailPopup(bool success, int questionId) {
    setState(() {
      for (int i = 0; i < answers.length; i++) {
        QuestionAnswer questionAnswer = answers[i];
        if (questionAnswer.question_id == questionId) {
          answers[i].isComplete = success;
        }
      }
      // answers.add(new QuestionAnswer(question_id: questionId, optional_message: comment));
    });
  }
}

class InspectionChild extends StatefulWidget {
  final Question question;
  final int index;
  final AlertDialogCallback callback;
  final String orderid;
  final String userId;
  final String categoryId;
  final String subCategoryId;
  final String defaultImage;

  InspectionChild(Question question, this.index, this.callback, this.orderid,
      this.userId, this.categoryId, this.subCategoryId,this.defaultImage)
      : question = question,
        super(key: new ObjectKey(question));

  @override
  InspectionChildState createState() {
    return new InspectionChildState(question, index, callback, orderid);
  }
}

class InspectionChildState extends State<InspectionChild> {
  final Question question;
  final AlertDialogCallback callback;
  final int index;
  final String orderid;


  InspectionChildState(this.question, this.index, this.callback, this.orderid);

  @override
  Widget build(BuildContext context) {
    question.message_option = 0;
    return getWidget(question);
  }

  // ignore: missing_return
  Widget getWidget(Question question) {
    String type = question.option_type;
    int photoOption = question.photo_option;
    int isDamageOption = question.is_damage_option;
    bool isHeader = callback.checkTitle(question.title);
    if (type == "radio") {
      for(int i =0 ; i < question.options.length ;i++)
        {
          Option option = question.options[i];
          if(question.input_var!=null && option.id == question.input_var.toInt())
            {
              if(option.title == "Fail")
                {
                  question.message_option = 1;
                }
            }
        }
      return radioTypeCamComment(
          data: question,
          text: question.title,
          parentIndex: index,
          headerStatus: isHeader);
    } else if (type == "file_upload") {
      return imageView(data: question, text: question.title, orderId: orderid,defaultImage: widget.defaultImage);
    } else if (type == "textbox") {
      return editView(
          data: question, text: question.title, headerStatus: isHeader);
    }else if (type == "textarea") {
      return editTextAreaView(
          data: question, text: question.title, headerStatus: isHeader);
    }
    else if (type == "checkbox") {
      return checkBox(
          data: question,
          text: question.title,
          parentIndex: index,
          headerStatus: isHeader);
    } else if (type == "radio") {
      return radioType(
          data: question,
          text: question.title,
          parentIndex: index,
          headerStatus: isHeader);
    } else if (type == "dropdown") {
      return dropDown(data: question, text: question.title ,headerStatus: isHeader);
    }
  }

  Widget radioType(
      {Question data,
      String text,
      GestureTapCallback onTap,
      int parentIndex,
      bool headerStatus}) {
    List<Option> optionsData = List();
/*    if (text != null) {
      optionsData.add(new Option(title: text));
    }*/
    optionsData.addAll(data.options);
    if (data.input_var != null && data.input_var.isNotEmpty) {
      for (int i = 0; i < data.options.length; i++) {
        Option option = data.options[i];
        if (data.input_var.toInt() == option.id) {
          data.value = option.title;
        }
      }
    }
    return Container(
        padding: EdgeInsets.all(8),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: StickyHeader(
              header: new Container(
                height: 38.0,
                color: headerStatus ? subHeaderBackground : Colors.white,
                padding: new EdgeInsets.symmetric(horizontal: 5.0),
                alignment: Alignment.centerLeft,
                child: new Text(
                  text,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              content: Container(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: optionsData.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 4,
                  ),
                  itemBuilder: (context, index) {
                    return singleRadio(data, optionsData[index], parentIndex,context);
                  },
                ),
              ),
            )));
    /*return ListTile(
        title: Container(
            height: 110,
        child: Card(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
    ),
            child: ListView.builder(
              controller: ScrollController(),
              scrollDirection: Axis.vertical,
              itemCount: optionsData.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return getText(text);
                } else {
                  return singleRadio(data, optionsData[index], parentIndex);
                }
              },
            ))));*/
  }

  Widget dropDown({Question data, String text, GestureTapCallback onTap,bool headerStatus}) {

    bool dropDownVisibilitySatus = false;
    String dropdownvalue = '';
    if(data.options.isNotEmpty) {
      setState(() {
        dropDownVisibilitySatus = true;
        if(data.input_var == "") {
          dropdownvalue = data.options[0].title;
        } else{
          dropdownvalue = data.input_var;
          bool isValueNotAvailable = true;
          for(int i =0; i < data.options.length; i++) {
            Option option = data.options[i];
            if(option.title == dropdownvalue){
              isValueNotAvailable = false;
              break;
            }
          }
          if(isValueNotAvailable){
            dropdownvalue = data.options[0].title;
          }
        }
        callback.valueUpdatedTextWithNoSetState(question.id, dropdownvalue);
      });
    }


    return Visibility(
        visible: dropDownVisibilitySatus,
      child:Container(
          padding: EdgeInsets.all(8),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: StickyHeader(
              header: new Container(
                height: 38.0,
                color: headerStatus ? subHeaderBackground : Colors.white,
                padding: new EdgeInsets.symmetric(horizontal: 5.0),
                alignment: Alignment.centerLeft,
                child: new Text(
                  text,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              content: Container(
                  padding: new EdgeInsets.symmetric(horizontal: 5.0),
                child: DropdownButton(
                  value: dropdownvalue,
                  icon: Icon(Icons.keyboard_arrow_down),
                  isExpanded: true,
                  items:data.options.map((Option items) {
                    return DropdownMenuItem(
                        value: items.title,
                        child: Text(items.title)
                    );
                  }
                  ).toList(),
                  onChanged: (String newValue){
                    setState(() {
                      data.input_var = newValue;
                      callback.valueUpdatedText(question.id, newValue);
                     // dropdownvalue = newValue;
                    });
                  },
                )
              ),
            ))));
  }

  Widget imageView({Question data, String text, String orderId,String defaultImage}) {
    log("defaultImage" + defaultImage);
    bool defaultValue;
    if(data.input_var == "N/A")
      defaultValue = true;
      else{
        defaultValue = false;
    }
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return primaryColor;
    }
    return ListTile(
      trailing: GestureDetector(
        behavior: HitTestBehavior.translucent,
        /*onTap: () {
           // log("<<<< inside checkbox tap");
            defaultValue = false;
            },*/

        child: Container(
          width: 80,
          height: 48,
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          alignment: Alignment.center,
          child:
          FlutterSwitch(
            activeText: "N/A",
            inactiveText: "",
            value: defaultValue,
            valueFontSize: 10.0,
            width: 60,
            borderRadius: 30.0,
            showOnOff: true,
            onToggle: (val) {

              setState(() {
                if(val) {
                  data.input_var = "N/A";
                  QuestionAnswer questionAnswer = new QuestionAnswer(question_id: data.id, answer: "N/A");
                  postInspectionQuestionAnswerForRequiredImage(widget.userId, orderId, widget.categoryId.toInt(), widget.subCategoryId.toInt(), questionAnswer);
                }
                else{
                  data.input_var  = "";
                }
              });
            },
          )
          /*ToggleSwitch(
            minWidth: 35.0,
            cornerRadius: 20.0,
            initialLabelIndex: 0,
            activeBgColors: [[Colors.cyan], [Colors.redAccent]],
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            totalSwitches: 2,
            icons: [Icons.check, Icons.close],
            onToggle: (index) {
              print('switched to: $index');
            },
          ),*/
          /*Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: defaultValue,
              onChanged: (bool value) {
                setState(() {
                  log("<<<< inside checkbox tap");
                  if(value) {
                    data.input_var = "N/A";
                    QuestionAnswer questionAnswer = new QuestionAnswer(question_id: data.id, answer: "N/A");
                    postInspectionQuestionAnswerForRequiredImage(widget.userId, orderId, widget.categoryId.toInt(), widget.subCategoryId.toInt(), questionAnswer);
                  }
                  else{
                    data.input_var  = "";
                  }
                });
              }),*/
        ),
          /*child: Checkbox(
              value: defaultValue,
              onChanged: (bool value) {
                setState(() {
                  defaultValue = value;
                });
              }),*/
      ),
      title:
    GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {_showPicker(context, data, orderId);},
        child:Row(
        children: <Widget>[
          File(data.input_var).existsSync()
              ? Image.file(
                  File(data.input_var.isNotEmpty && data.input_var != "N/A" ? data.input_var:defaultImage),
                  height: 50,
                  width: 70,
                )
              : FadeInImage.assetNetwork(
                  placeholder: cupertinoActivityIndicator,
                  image: data.input_var.isNotEmpty && data.input_var != "N/A" ? data.input_var:defaultImage,
                  height: 50,
                  width: 70,
                  placeholderScale: 5),
          Flexible(
              child: Padding(
            padding: EdgeInsets.only(top: 10, left: 10),
            child: Text(text),
          )),
        ],
      )),
     /* onTap: () {
        _showPicker(context, data, orderId);
      },*/
    );
  }

  Future<InspectionPostResponse> postInspectionQuestionAnswerForRequiredImage(String userId,
      String orderId, int category_id, int sub_category_id,QuestionAnswer answer) async {

    log('data1: ' + orderId);
    List<QuestionAnswer>answers = new List();
    answers.add(answer);
    PostInspectionOptionsData postInspectionOptionsData =
    PostInspectionOptionsData();
    postInspectionOptionsData.user_id = userId.toInt();
    postInspectionOptionsData.order_id = orderId.toInt();
    postInspectionOptionsData.sub_category_id = sub_category_id;
    postInspectionOptionsData.category_id = category_id;
    postInspectionOptionsData.answers = answers;
    final response = await http.post(
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(postInspectionOptionsData.toJson()),
    );
    log('data1: ' + 'after api call');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      log('data1: ' + response.body);
      return InspectionPostResponse.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      log('data1: ' + 'exception');
      throw Exception('Failed to load data');
    }
  }

  void _showPicker(context, Question data, String orderId) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _getFromCamera(data, orderid);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  /// Get from Camera
  _getFromCamera(Question data, String orderid) async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      if (pickedFile != null) {
        // call api to save image
        upload(File(pickedFile.path), data, orderid);
      }
    });
  }

  upload(File imageFile, Question data, String orderid) async {
    setState(() {
      data.input_var = imageFile.path;
    });
    ImagePostData postData = ImagePostData();
    postData.fileName = 'file_${orderid}_${data.id}';
    postData.filePath = imageFile.path;
    callback.valueUpdateImage(postData);
  }

  Widget
  editView(
      {Question data,
      String text,
      GestureTapCallback onTap,
      bool headerStatus}) {
    FixedOffsetTextEditingController controller = FixedOffsetTextEditingController();
    controller.text = data.input_var;
    return Container(
        height: 120,
        padding: EdgeInsets.all(8),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  color: headerStatus ? subHeaderBackground : Colors.white,
                  alignment: Alignment.topLeft,
                  padding:
                      EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 5),
                  child: Text(
                    text,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Flexible(
                    child: Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: controller,
                    maxLines: 1,
                    /*onFieldSubmitted: (answer) {
                      setState(() {
                        question.input_var = answer;
                        callback.valueUpdatedText(question.id, answer);
                      });
                    },*/
                    onChanged: (answer){
                      setState(() {
                        question.input_var = answer;
                        callback.valueUpdatedText(question.id, answer);
                      });

                    },
                    style: TextStyle(
                      fontSize: 14,
                      color: appStore.appTextPrimaryColor,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(26, 18, 4, 18),
                      hintText: "Enter data",
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
                  ),
                )),
              ],
            )));
  }

  Widget
  editTextAreaView(
      {Question data,
        String text,
        GestureTapCallback onTap,
        bool headerStatus}) {
    FixedOffsetTextEditingController controller = FixedOffsetTextEditingController();
    controller.text = data.input_var;
    return Container(
        padding: EdgeInsets.all(8),
        height: MediaQuery.of(context).size.height,
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  color: headerStatus ? subHeaderBackground : Colors.white,
                  alignment: Alignment.topLeft,
                  padding:
                  EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 5),
                  child: Text(
                    text,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: controller,
                        maxLines: null,
                        /*onFieldSubmitted: (answer) {
                      setState(() {
                        question.input_var = answer;
                        callback.valueUpdatedText(question.id, answer);
                      });
                    },*/
                        onChanged: (answer){
                          setState(() {
                            question.input_var = answer;
                            callback.valueUpdatedText(question.id, answer);
                          });

                        },
                        style: TextStyle(
                          fontSize: 14,
                          color: appStore.appTextPrimaryColor,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(26, 18, 4, 18),
                          hintText: "Enter data",
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
                      ),
                    )),
              ],
            )));
  }

  Widget checkBox(
      {Question data,
      String text,
      GestureTapCallback onTap,
      int parentIndex,
      bool headerStatus}) {
    List<Option> optionsData = List();
    /*if (text != null) {
      optionsData.add(new Option(title: text));
    }*/
    optionsData.addAll(data.options);
    if (data.input_var != null && data.input_var.isNotEmpty) {
      List<String> list  = data.input_var.split(",");
      List<String> valueList = List();
      for (int i = 0; i < data.options.length; i++) {
        Option option = data.options[i];
        if (list.contains(option.id.toString())) {
          valueList.add(option.title);
        }
      }
      if(valueList.isNotEmpty){
        data.value = valueList.join(",");
      } else {
        data.value = "";
      }
    }
    return Container(
        padding: EdgeInsets.all(8),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: StickyHeader(
              header: new Container(
                height: 38.0,
                color: headerStatus ? subHeaderBackground : Colors.white,
                padding: new EdgeInsets.symmetric(horizontal: 5.0),
                alignment: Alignment.centerLeft,
                child: new Text(
                  text,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              content: Container(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: optionsData.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 4,
                  ),
                  itemBuilder: (context, index) {
                    return singleCheckBox(optionsData[index], parentIndex);
                  },
                ),
              ),
            )));
    /*   return ListTile(
        title: Container(
            height: 50,
            child: ListView.builder(
              controller: ScrollController(),
              scrollDirection: Axis.horizontal,
              itemCount: optionsData.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return getText(text);
                } else {
                  return singleCheckBox(optionsData[index], parentIndex);
                }
              },
            )));*/
  }

  Widget radioTypeCamComment(
      {Question data,
      String text,
      GestureTapCallback onTap,
      int parentIndex,
      bool headerStatus}) {
    List<Option> optionsData = List();
    optionsData.addAll(data.options);

    int numberOrRows = 2;
    double aspectRatio = 4;

    if(data.title == 'Rating') {
      numberOrRows = 1;
      aspectRatio = 8;
    }
    /*if (text != null) {
      optionsData.add(new Option(title: text));
    }
    optionsData.addAll(data.options);
    if (data.photo_option == 1) {
      optionsData.add(new Option(title: "Camera"));
    }
    if (data.message_option == 1) {
      optionsData.add(new Option(title: "message"));
    }*/

    bool failPopUpStatus = false;
    if(data.is_damage_option == 2)
      {
        failPopUpStatus = true;
      }
    if (data.input_var != null && data.input_var.isNotEmpty) {
      for (int i = 0; i < data.options.length; i++) {
        Option option = data.options[i];
        if (data.input_var.toInt() == option.id) {
          data.value = option.title;
        }
      }
    }
    return Container(
        padding: EdgeInsets.all(8),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: StickyHeader(
              header: new Container(
                  color: headerStatus ? subHeaderBackground : Colors.white,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                    Container(
                      height: 38.0,
                      padding: new EdgeInsets.symmetric(horizontal: 5.0),
                      alignment: Alignment.centerLeft,
                      child: new Text(
                        text,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    new Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          if (data.message_option == 1) commentIcon(data,parentIndex,failPopUpStatus),
                          /*if (data.photo_option == 1) cameraIcon(),*/
                          if (data.is_damage_option == 1) damageIcon()
                        ])
                  ])),
              content: Container(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: optionsData.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: numberOrRows,
                    childAspectRatio: aspectRatio,
                  ),
                  itemBuilder: (context, index) {
                    return singleRadio(data, optionsData[index], parentIndex, context);
                  },
                ),
              ),
            )));
    /*return ListTile(
        title: Container(
            height: 50,
            child: ListView.builder(
              controller: ScrollController(),
              scrollDirection: Axis.horizontal,
              itemCount: optionsData.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return getText(text);
                } else if (index == optionsData.length - 2) {
                  return commentIcon();
                } else if (index == optionsData.length - 1) {
                  return cameraIcon();
                } else {
                  return singleRadio(data, optionsData[index], parentIndex);
                }
              },
            )));*/
  }

  Widget getText(String text) {
    return Container(
      padding: EdgeInsets.only(right: 5.0, left: 5),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget cameraIcon() {
    return InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return new MyCameraDialog(
                  callback: widget.callback,
                  question: question,
                  orderId: orderid,
                  // ignore: missing_return
                );
              });
        },
        child: Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Icon(Icons.photo_camera),
        ));
  }


 /* Future showFailDialog(BuildContext context)  async {
    TextEditingController controller = TextEditingController();
    controller.text = widget.question.saved_message_option;
    List<ImagePostData> postDataList = List();
    List<Images> imageList = List();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: appStore.scaffoldBackground,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)), //this right here
            child: Container(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: TextFormField(
                              controller: controller,
                              style: TextStyle(
                                fontSize: 14,
                                color: appStore.appTextPrimaryColor,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(26, 18, 4, 18),
                                hintText: "Enter data",
                                filled: true,
                                hintStyle:
                                TextStyle(color: appStore.textSecondaryColor),
                                fillColor: appStore.editTextBackColor,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                  BorderSide(color: Colors.white, width: 0.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                  BorderSide(color: Colors.white, width: 0.0),
                                ),
                              ),
                            ),
                          ),
                          16.height,
                          InkWell(
                              onTap: () {
                                //_showPicker(context);
                              },
                              child: Container(
                                  width: 20,
                                  padding: EdgeInsets.only(top: 10),
                                  child: const Icon(Icons.add_photo_alternate))),
                          16.height,
                          Visibility(
                            visible: imageList.isNotEmpty,
                            child: Container(
                                margin: EdgeInsets.only(top: 10),
                                height: 100,
                                child: ListView(
                                    padding: EdgeInsets.all(2.0),
                                    scrollDirection: Axis.horizontal,
                                    physics: const ScrollPhysics(),
                                    children: List.generate(imageList.length, (index) {
                                      return ImagePost(imageList[index],index, this);
                                    }).toList())),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, left: 10),
                            height: 40,
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                                color: primaryColor,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                )),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  question.saved_message_option = controller.text;
                                  callback.updateValueForComment(
                                      question.id, controller.text);
                                });
                               // Navigator.of(context).pop();
                              },
                              child: Text(
                                'Submit',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ]))));
      },
    );
  }*/

  /*Future showCommentDialog1(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    controller.text = widget.question.saved_message_option;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: appStore.scaffoldBackground,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)), //this right here
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
                            fontSize: 14,
                            color: appStore.appTextPrimaryColor,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(26, 18, 4, 18),
                            hintText: "Enter data",
                            filled: true,
                            hintStyle:
                                TextStyle(color: appStore.textSecondaryColor),
                            fillColor: appStore.editTextBackColor,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.0),
                            ),
                          ),
                        ),
                      ),
                      16.height,
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 40),
                        height: 40,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            )),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              question.saved_message_option = controller.text;
                              callback.updateValueForComment(
                                  question.id, controller.text);
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ]))));
      },
    );
  }*/

  Widget commentIcon(Question data,int parentIndex, bool failPopUpStatus) {
    return InkWell(
        onTap: () {
          Option option;
          for (int i = 0; i < data.options.length; i++) {
            Option tempOption = data.options[i];
            if (data.input_var.toInt() == tempOption.id) {
              if(tempOption.title == "Fail")
                {
                  option = tempOption;
                }
            }
          }
          if(option != null)
             callback.valueUpdatedRadio(option, data.id,data,failPopUpStatus,widget.categoryId,widget.subCategoryId);
          /*showDialog(
              context: context,
              builder: (BuildContext context) {
                return new MyCameraDialog(
                    callback: callback,
                    question: data,
                    orderId: orderid,
                    parentIndex: parentIndex
                  // ignore: missing_return
                );
              });*/
        },
        child: Padding(
          padding: EdgeInsets.only(left: 12.0,right: 12.0),
          child: Icon(Icons.comment),
        ));
  }

  Widget damageIcon() {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => DamageList(
                    userId: widget.userId ,
                    categoryId:widget.categoryId ,
                    orderId: widget.orderid,
                    subCategoryId: widget.subCategoryId,
                    name: question.title,
                    questionId: question.id.toString(),
                  )));;
        },
        child: Padding(
          padding: EdgeInsets.only(left: 12.0,right: 12.0),
          child: Text("Damage",style: TextStyle(
            decoration: TextDecoration.underline,
          ),),
        ));
  }

  Widget singleRadio(Question data, Option option, int parentIndex, BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          child: Radio<String>(
            value: option.title != null ? option.title : "NA",
            onChanged: (String value) {
              setState(() {
                question.value = option.title.toString();
                question.input_var = option.id.toString();
                callback.valueUpdatedRadio(option, data.id,data,data.is_damage_option == 2 ? true : false,widget.categoryId,widget.subCategoryId);
              });
            },
            groupValue: question.value,
          ),
        ),
        Flexible(
          child: Container(
            width: MediaQuery.of(context).size.width / 4,
        child: Text( option.title != null ? option.title : "NA"
        ),
        ),
        ),//Text

      ],
    );
  }

  Widget singleCheckBox(Option option, int parentIndex) {
    return Row(
      children: <Widget>[
        Container(
            child: Checkbox(
                value: getValue(option.id.toString(), option.title),
                onChanged: (bool value) {
                  setState(() {
                    callback.valueUpdatedCheckBox(
                        option, question.id, value, question);
                  });
                })),
        Container(
          padding: EdgeInsets.all(5),
          child: Text(option.title != null ? option.title : "NA"),
        ), //Text
        /** Checkbox Widget **/

      ],
    );
  }

  bool getValue(String id, String title) {
    String inputVar = question.input_var;
    String value = question.value;
    if (inputVar.isEmpty && value.isEmptyOrNull) {
      return false;
    } else {
      List<String> list;
      if(inputVar.isEmptyOrNull) {
        list = List();
      }
      else {
        list = inputVar.split(",");
      }
      List<String> valueList;
      if(value.isEmptyOrNull) {
        valueList = List();
      }
      else {
        valueList = value.split(",");
      }
        return list.contains(id) || valueList.contains(title);
      }
    }
}

abstract class AlertDialogCallback {
  void valueUpdatedRadio(Option option, int parentIndex, Question data, bool failPopUpStatus, String categoryId, String subCategoryId);

  void valueUpdatedCheckBox(
      Option option, int questionId, bool add, Question question);

  void valueUpdatedText(int questionId, String answer);

  void valueUpdatedTextWithNoSetState(int questionId, String answer);

  void valueUpdateImage(ImagePostData postData);

  void uploadOptionalImages(List<ImagePostData> list);

  bool checkTitle(String title);

  void updateValueForComment(int questionId, String comment , int parentIndex, bool isComplete);
  void valueUpdatedForFailPopup(bool success, int questionId);
}

class ImagePostData {
  String fileName;
  String filePath;
}


// Fail pop up for Interior and Mechanical





//Fail pop up

class MyCameraDialog extends StatefulWidget {
  const MyCameraDialog({this.callback, this.question, this.orderId, this.parentIndex});

  final AlertDialogCallback callback;
  final Question question;
  final String orderId;
  final int parentIndex;

  @override
  State createState() => new MyCameraDialogState();
}

class MyCameraDialogState extends State<MyCameraDialog> implements DeleteImageCallback {
  List<ImagePostData> postDataList = List();
  List<Images> imageList = List();
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.question.saved_optional_images != null &&
        widget.question.saved_optional_images.isNotEmpty) {
      imageList.addAll(widget.question.saved_optional_images);
    }
    controller.text = widget.question.saved_message_option;

  }

  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: appStore.scaffoldBackground,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)), //this right here
        child: Container(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: controller,
                      style: TextStyle(
                        fontSize: 14,
                        color: appStore.appTextPrimaryColor,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(26, 18, 4, 18),
                        hintText: "Enter data",
                        filled: true,
                        hintStyle:
                        TextStyle(color: appStore.textSecondaryColor),
                        fillColor: appStore.editTextBackColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          BorderSide(color: Colors.white, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                          BorderSide(color: Colors.white, width: 0.0),
                        ),
                      ),
                    ),
                  ),
              InkWell(
                  onTap: () {
                    _showPicker(context);
                  },
                  child:Column(children: [
              Container(
              height: 38.0,
                  color: Colors.white,
                  padding: new EdgeInsets.symmetric(horizontal: 5.0),
                  alignment: Alignment.center,
                  child: new Text(
                    'Add picture',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
                  Container(
                      width: 40,
                      padding: EdgeInsets.only(top: 10),
                      child: const Icon(Icons.add_photo_alternate,size: 50,))])),
              16.height,
              Visibility(
                visible: imageList.isNotEmpty,
                child: Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 100,
                    child: ListView(
                        padding: EdgeInsets.all(2.0),
                        scrollDirection: Axis.horizontal,
                        physics: const ScrollPhysics(),
                        children: List.generate(imageList.length, (index) {
                          return ImagePost(imageList[index], this, index);
                        }).toList())),
              ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 40,
                        width: MediaQuery.of(context).size.width / 4,
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                          onPressed: () {
                            bool isComplete = true;
                            widget.question.saved_message_option = controller.text;
                            if(imageList.isEmpty || controller.text.isEmpty) {
                              isComplete = false;
                            }
                            widget.callback.updateValueForComment(
                                widget.question.id, controller.text, widget.parentIndex, isComplete);
                            Navigator.of(context).pop();
                            widget.callback.uploadOptionalImages(postDataList);
                          },
                          child: Text(
                            'Close',
                            style: TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 40,
                        width: MediaQuery.of(context).size.width / 4,
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                          onPressed: () {
                            bool isComplete = true;
                            widget.question.saved_message_option = controller.text;
                            if(imageList.isEmpty || controller.text.isEmpty) {
                              isComplete = false;
                            }
                            widget.callback.updateValueForComment(
                                widget.question.id, controller.text, widget.parentIndex, isComplete);
                            Navigator.of(context).pop();
                            widget.callback.uploadOptionalImages(postDataList);
                          },
                          child: Text(
                            'Save',
                            style: TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ),

                    ],
                  ),
              /*Container(
                margin: EdgeInsets.only(top: 10),
                height: 40,
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                    color: primaryColor,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    )),
                child: TextButton(
                  onPressed: () {
                    bool isComplete = true;
                      widget.question.saved_message_option = controller.text;
                      if(imageList.isEmpty || controller.text.isEmpty) {
                        isComplete = false;
                      }
                      widget.callback.updateValueForComment(
                          widget.question.id, controller.text, widget.parentIndex, isComplete);
                    Navigator.of(context).pop();
                    widget.callback.uploadOptionalImages(postDataList);
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),*/
            ]))));
  }

  void _showPicker(context) {
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
                        getFromGallery1();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _getFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  /// Get from gallery
  getFromGallery1() async {
    List<AssetEntity> resultList = await AssetPicker.pickAssets(context, textDelegate: EnglishTextDelegate());
    setState(() async {
      if (resultList.isNotEmpty) {
        for (int i = 0; i < resultList.length; i++) {
          final filePath = await FlutterAbsolutePath.getAbsolutePath(
              (await resultList[i].originFile).path);
          upload(File(filePath));
        }
      }
    });
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      if (pickedFile != null) {
        // call api to save image
        upload(File(pickedFile.path));
      }
    });
  }

  upload(File imageFile) async {
    ImagePostData postData = ImagePostData();
    postData.filePath = imageFile.path;
    String fileName =
        "file_${widget.orderId}_${widget.question.id}_optional_${postDataList.length + 1}";
    postData.fileName = fileName;
    setState(() {
      imageList.add(Images(id: 1, image: imageFile.path));
      widget.question.saved_optional_images = imageList;
      postDataList.add(postData);
    });
  }

  @override
  void valueUpdated(bool success, int index) {
    if (success)
    {
      log("<<<Deleted image");
      setState(() {
        imageList.removeAt(index);
        if(postDataList.isNotEmpty){
          postDataList.removeAt(index);
        }
      });
      Fluttertoast.showToast(
          msg: "Successfully deleted image.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    }
}
}

class ImagePost extends StatefulWidget {
  final Images postData;
  final int index;
  final DeleteImageCallback callback;

  ImagePost(Images data, this.callback, this.index)
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
    return getWidget(postData,context);
  }

  // ignore: missing_return
  Widget getWidget(Images postData, BuildContext context) {
    return imageView(data: postData,context: context);
  }

  Widget imageView({Images data, BuildContext context}) {
    return Container(
      width: 70,
      padding: EdgeInsets.all(3),
      child: File(data.image).existsSync()
          ? Stack(children: <Widget>[ Image.file(
        File(data.image),
        height: 40,
        width: 40,
      ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: (){
              if(File(data.image).existsSync()) {
                File(data.image).delete();
              }
              widget.callback.valueUpdated(true, widget.index);
              _deleteOptionImage(context).then((value) =>{
                if( value.success)
                  {

                  }
                else{

                }
              });
              log('delete image from List');
              setState((){
                print('set new state of images');
              });
            },
            child: Icon(
              Icons.close,
            ),
          ),
        ),])
          : Stack(children: <Widget>[FadeInImage.assetNetwork(
              placeholder: cupertinoActivityIndicator,
              image: data.image,
              height: 40,
              width: 40,
              placeholderScale: 5),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: (){
              _deleteOptionImage(context).then((value) =>{
                if( value.success)
                  {
                    widget.callback.valueUpdated(true, widget.index)
                  }
                else{

                }
              });
              log('delete image from List');
              setState((){
                print('set new state of images');
              });
            },
            child: Icon(
              Icons.close,
            ),
          ),
        ),]),
    );
  }


  Future<InspectionPostResponse> _deleteOptionImage(BuildContext context) async {
    final response = await http.post(
      headers: <String, String>
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'optional_img_id': postData.id,

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

abstract class DeleteImageCallback {
  void valueUpdated(bool success, int index);
}
