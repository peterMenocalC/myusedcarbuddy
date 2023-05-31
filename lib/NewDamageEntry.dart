
import 'package:flutter/cupertino.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_app_mucb/model/DamageEntry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_mucb/model/InspectionOptionsData.dart';
import 'package:flutter_app_mucb/utils/Colors.dart';
import 'package:flutter_app_mucb/utils/FixedOffsetTextEditingController.dart';
import 'package:focus_detector/focus_detector.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:loading_gifs/loading_gifs.dart';
import 'package:nb_utils/nb_utils.dart';

import 'ErrorView.dart';
import 'InspectionVehicleDetails.dart';
import 'NoInternetConnection.dart';
import 'main.dart';
import 'dart:developer';
import 'package:async/async.dart';

import 'dart:io';
import 'package:http_parser/http_parser.dart';

import 'model/PostInspectionOptionsData.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class NewDamageEntry extends StatefulWidget {
  final userId;
  List<Images>imageList = new List();
  final questionId;
  final orderId;
  final damageTypeId;
  final damageSizeId;
  var damageId;
  String notes;


  FixedOffsetTextEditingController controller = FixedOffsetTextEditingController();


  NewDamageEntry({
    Key key,
    @required this.userId, @required this.questionId,@required this.orderId,@required this.damageTypeId, @required this.damageSizeId,@required this.notes,@required this.imageList , @required this.damageId
  }) : super(key: key);

  @override
  _NewDamageEntryState createState() => _NewDamageEntryState(notes);
}

class _NewDamageEntryState extends State<NewDamageEntry> implements DeleteImageCallback{
  bool mIsLoading = false;
  DamageEntry damageEntry = new DamageEntry();
  final ScrollController scrollController = ScrollController();
  List<ImagePostData>imagePostList = new List();
  List<ImagePostData>imagePostListWithoutDamageId = new List();
  String notes;

  _NewDamageEntryState(this.notes);

  @override
  void initState() {
    super.initState();
    getInspectionOrderDetails();
  }

  Future<void> getInspectionOrderDetails() async {
    setState(() {
      mIsLoading = true;
    });
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await getDamageListData(widget.userId).then((res) async {
          mIsLoading = false;
          setState(() {
            damageEntry = res;
            log("<<type" +  damageEntry.damages[widget.damageTypeId].id.toString());
            damageEntry.value = damageEntry.damages[0].title;
            damageEntry.sizeValue = damageEntry.damages[0].size[0].title;
            damageEntry.sizeIndex = 0;
            damageEntry.typeIndex =0;
            damageEntry.typeId = damageEntry.damages[0].id.toString();
            damageEntry.sizeId = damageEntry.damages[0].size[0].id.toString();
            damageEntry.damages.asMap().forEach((index,DamageItem damageItem) {
              if (damageItem.id == widget.damageTypeId) {
                damageEntry.value = damageItem.title;
                damageEntry.typeIndex = index;
                damageEntry.typeId = damageItem.id.toString();
                log("value " + damageEntry.value + " typeIndex " + damageEntry.typeIndex.toString() +" typeId " + damageEntry.typeId );
                damageItem.size.asMap().forEach((index,Size size  ){
                  if(size.id == widget.damageSizeId)
                    {
                      damageEntry.sizeValue = size.title;
                      damageEntry.sizeIndex = index;
                      damageEntry.sizeId = size.id.toString();
                      log("value " + damageEntry.sizeValue + " sizeIndex " + damageEntry.sizeIndex.toString() +" sizeId " + damageEntry.sizeId );
                      return;
                    }
                });
                return;
              }
              /*else {
                damageEntry.value = damageEntry.damages[0].title;
                damageEntry.sizeValue = damageEntry.damages[0].size[0].title;
                damageEntry.sizeIndex = 0;
                damageEntry.typeIndex =0;
              }*/
            });

            //log("<<size" + damageEntry.damages[int.parse(widget.damageTypeId)].size[int.parse(widget.damageSizeId)].id.toString());
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

  Future<DamageEntry> getDamageListData(String userId) async {
    final response = await http.post(
      Uri.https('''', 'api/inspection-damaged-options'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'user_id': userId,
      }),
    );
    log('data1: ' + 'after api call');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      log('data1: ' + response.body);
      return DamageEntry.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      log('data1: ' + 'exception');

      throw Exception('Failed to load data');
    }
  }


  @override
  Widget build(BuildContext context) {
    widget.controller.text = notes;
    return FocusDetector(
        onFocusGained: () {
          //getInspectionOrderDetails();
        },
        child: new Scaffold( resizeToAvoidBottomInset: false,
            appBar: AppBar(
            title: Text("Add damage"),
          ),
          body: new Stack(
            children: [
              ListView(
                  reverse: true,
                  shrinkWrap : true,
                  padding: const EdgeInsets.all(8),
                  children: <Widget>[
                Container(
                    height: 38.0,
                    color: Colors.white,
                    padding: new EdgeInsets.symmetric(horizontal: 5.0),
                    alignment: Alignment.centerLeft,
                    child: new Text(
                      'Type',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )),
                Visibility(
                  visible: damageEntry.damages !=null,
                  child: Container(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: damageEntry.damages!=null ? damageEntry.damages.length : 0,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 4,
                      ),
                      itemBuilder: (context, index) {
                        return singleRadio(damageEntry.damages[index], index);
                      },
                    ),
                  ),
                ),),
                Container(
                    height: 38.0,
                    color: Colors.white,
                    padding: new EdgeInsets.symmetric(horizontal: 5.0),
                    alignment: Alignment.centerLeft,
                    child: new Text(
                      'Size',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )),
          Visibility(
              visible: damageEntry.damages!=null, child :Container(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: damageEntry.damages!=null ? damageEntry.damages[damageEntry.typeIndex].size.length : 0,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 4,
                      ),
                      itemBuilder: (context, index) {
                        return singleRadioSize(damageEntry.damages[damageEntry.typeIndex].size[index]);
                      },
                    ),
                  ),
                ),),
                Container(
                    height: 38.0,
                    color: Colors.white,
                    padding: new EdgeInsets.symmetric(horizontal: 5.0),
                    alignment: Alignment.centerLeft,
                    child: new Text(
                      'Notes',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )),
                Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: TextFormField(
                        controller: widget.controller,
                        onFieldSubmitted: (answer) {
                          setState(() {
                            notes = answer;
                          });
                        }
                        ,
                        onChanged: (answer){
                          setState(() {
                            notes = answer;
                            widget.controller.text = notes;
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
                        child: const Icon(Icons.add_photo_alternate,size: 50,)),

                    ])),
                16.height,
                Visibility(
                  visible: widget.imageList.isNotEmpty,
                  child: Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 100,
                      child: ListView(
                          padding: EdgeInsets.all(2.0),
                          scrollDirection: Axis.horizontal,
                          physics: const ScrollPhysics(),
                          children: List.generate(widget.imageList.length, (index) {
                            return ImagePost(widget.imageList[index],index, this);
                          }).toList())),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  height: 40,
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        mIsLoading = true;
                      });
                      addDamageEntry();
                    },
                    child: Text(
                      'Add damage',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                )
              ].reversed.toList()),
              mIsLoading
                  ? Container(
                      child: CircularProgressIndicator(),
                      alignment: Alignment.center,
                    )
                  : SizedBox(),
            ],
          ),
        ));
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
          if(widget.damageId == "")
            {
              uploadWithoutDamageId(File(filePath));
            }
          else{
            upload(File(filePath));
          }

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
        if(widget.damageId == "")
        {
          uploadWithoutDamageId(File(pickedFile.path));
        }
        else{
          upload(File(pickedFile.path));
        }
      }
    });
  }

  uploadWithoutDamageId(File imageFile) async{
    ImagePostData imagePostData = ImagePostData();
    imagePostData.filePath = imageFile.path;
    String fileName =
        "file_${widget.damageId}_${widget.imageList.length + 1}";
    log("value" + fileName);
    imagePostData.fileName = fileName;
    setState(() {
      widget.imageList.add(Images(id: 1, image: imageFile.path));
      imagePostListWithoutDamageId.add(imagePostData);
    });
  }

  upload(File imageFile) async {
    Images postData = Images();
    ImagePostData imagePostData = ImagePostData();
    imagePostData.filePath = imageFile.path;
    postData.image = imageFile.path;
    String fileName =
       "file_${widget.damageId}_${widget.imageList.length + 1}";
    log("value" + fileName);
    imagePostData.fileName = fileName;
    setState(() {
      widget.imageList.add(Images(id: 1, image: imageFile.path));
      imagePostList.add(imagePostData);
        uploadImage(imagePostList,false);
    });
  }

  uploadImage(List<ImagePostData> list, bool from) async {
    if (list.isEmpty) {
      return;
    }
    setState(() {
      mIsLoading = true;
    });
    var uri =
    Uri.parse("https://''/api/inspection-damage-image-save");
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
    /*File file = File(postData.image);
    var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
    var length = await file.length();
    var multipartFile = new http.MultipartFile(
        filename, stream, length,
        filename: filename, contentType: MediaType("image", "jpeg"));
    request.files.add(multipartFile);*/
    var response = await request.send();
    if (response.statusCode == 200) {
      setState(() {
        mIsLoading = false;
        if(from)
          Navigator.pop(context);

      });
    } else {
      setState(() {
        mIsLoading = false;
      });
      NoInternetConnection().launch(context);
    }
  }

  Widget singleRadio(DamageItem option, int index) {
    return Row(
      children: <Widget>[
        Container(
          child: Radio<String>(
            value: option.title,
            onChanged: (String value) {
              setState(() {
                damageEntry.value = option.title;
                damageEntry.typeIndex = index;
                damageEntry.typeId = option.id.toString();
              });
            },
            groupValue: damageEntry.value,
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          child: Text(option.title != null ? option.title : "NA"),
        ), //Text
      ],
    );
  }
  Widget singleRadioSize(Size option) {
    return Row(
      children: <Widget>[
        Container(
          child: Radio<String>(
            value: option.title,
            onChanged: (String value) {
              setState(() {
                damageEntry.sizeValue = option.title;
                damageEntry.sizeId = option.id.toString();
              });
            },
            groupValue: damageEntry.sizeValue,
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          child: Text(option.title != null ? option.title : "NA"),
        ), //Text
      ],
    );
  }

  Future<void> addDamageEntry() async {
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        getFinish(widget.orderId,widget.questionId,damageEntry.typeId,damageEntry.sizeId,widget.controller.text,widget.damageId)
            .then((value) => {
          if (value.success)
            {
              if(widget.damageId == "")
                {
                  widget.damageId = value.savedDamageId,
                  if(imagePostListWithoutDamageId.isNotEmpty)
                    {
                      uploadImagesAfterDamageId(value.savedDamageId)
                    }
                  else{
                    setState(() {
                      mIsLoading = false;
                    }),
                    Fluttertoast.showToast(
                        msg: "Success - Added damage entry.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 16.0),
                    Navigator.pop(context)
                  }
                }
              else
                {
                  setState(() {
                    mIsLoading = false;
                  }),
                  Fluttertoast.showToast(
                      msg: "Success - Added damage entry.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 16.0),
                  Navigator.pop(context)
                }
            }
          else
            {
              setState(() {
                mIsLoading = false;
              }),
              Fluttertoast.showToast(
                  msg: "Failed.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0)
            }
        })
            .catchError((e) {
          setState(() {
            mIsLoading = false;
          });
          Fluttertoast.showToast(
              msg: "Failed.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        });
      } else {
        setState(() {
          mIsLoading = false;
        });
        NoInternetConnection().launch(context);
      }
    });
  }

  Future<AcceptRejectResponse> getFinish(String orderId,String questionId, String typeId,String sizeId, String notes ,String damageId) async {
    log("API response <<<<" + orderId+ "  "+ questionId+ "  --" + typeId+ "--" + sizeId + "---" + notes);
    final response = await http.post(
      Uri.https('''', 'api/inspection-damage-save'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'order_id': orderId,
        'qn_id': questionId,
        'damage_type_id': typeId,
        'damage_size_id': sizeId,
        'notes': notes,
        'edit_id': damageId
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      log('data1: ' + response.body);
      return AcceptRejectResponse.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      log('data1: ' + 'exception' + response.body);

      throw Exception('Failed to load data');
    }
  }

  @override
  void valueUpdated(bool success, int index) {
    if (success)
    {
      log("<<<Deleted image");
      setState(() {
        widget.imageList.removeAt(index);
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

  uploadImagesAfterDamageId(String savedDamageId) {
    for (int i = 0; i < imagePostListWithoutDamageId.length; i++) {
      ImagePostData postData = imagePostListWithoutDamageId[i];
      postData.fileName = "file_${widget.damageId}_${i + 1}";
    }
    uploadImage(imagePostListWithoutDamageId,true);
  }

}
class ImagePostData {
  String fileName;
  String filePath;
}

class ImagePost extends StatefulWidget {
  final Images postData;
  final index;
  final DeleteImageCallback callback;


  ImagePost(Images data, int index, DeleteImageCallback callback) : postData = data, index = index, callback = callback,
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
             /* if(File(data.image).existsSync()) {
                File(data.image).delete();
              }
              widget.callback.valueUpdated(true, widget.index);*/
              _deleteDamageImage(context).then((value) =>{
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
        ),])
          :Stack(children: <Widget>[FadeInImage.assetNetwork(
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
              _deleteDamageImage(context).then((value) =>{
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

  Future<InspectionPostResponse> _deleteDamageImage(BuildContext context) async {
    final response = await http.post(
      Uri.https('''', 'api/inspection-damage-images-delete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'saved_damage_image_id': postData.id,

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