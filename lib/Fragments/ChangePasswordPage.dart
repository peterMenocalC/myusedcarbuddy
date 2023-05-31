import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_mucb/model/ForgotPasswordResponse.dart';
import 'package:flutter_app_mucb/utils/Colors.dart';
import 'package:flutter_app_mucb/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;

import '../navigationDrawer.dart';
import 'HomePage.dart';

class ChangePasswordPage extends StatefulWidget {

  static const String routeName = '/ChangePasswordPage';
  final name;
  final userId;

  ChangePasswordPage({Key key, @required this.name, @required this.userId})
      : super(key: key);
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  var autoValidate = false;
  final oldPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        child: Scaffold(
        appBar: AppBar(
        title: Text("Change Password"),
    backgroundColor: primaryColor,
    ),
    drawer: navigationDrawer(name: widget.name),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Center(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('asset/images/app_logo.png')),
              ),
            ),
            /*Padding(
              padding: const EdgeInsets.only(top: 150.0),
              child: Center(
                child: Container(
                    height: 60,
                    *//*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*//*
                    child: Text(
                      'Set Password',
                      style: TextStyle(color: Colors.black, fontSize: 35),
                    )),
              ),
            ),*/
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    EditText(
                      hintText: "Enter old Password*",
                      isPassword: true,
                      mController: oldPasswordController,
                      isSecure: true,
                      validator: (String s) {
                        if (s.trim().isEmpty) return "Old Password" + " " + "Field required";
                        return null;
                      },
                    ),
                    20.height,
                    EditText(
                      hintText: "Enter new Password*",
                      isPassword: true,
                      mController: passwordController,
                      isSecure: true,
                      validator: (String s) {
                        if (s.trim().isEmpty) return "Password" + " " + "Field required";
                        return null;
                      },
                    ),
                    20.height,
                    EditText(
                      hintText: "Confirm new Password*",
                      isPassword: true,
                      mController: confirmPasswordController,
                      isSecure: true,
                      validator: (String s) {
                        if (s.trim().isEmpty) return "Confirm Password" + " " + "Field required";
                        if(s.trim() != passwordController.text) return "Confirm password did not match";
                        return null;
                      },
                    ),
                    20.height,
                  ],
                ),
              ),
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              /*padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter password'),
              ),
            ),
            Padding(
               padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 15),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(

                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    hintText: 'Enter same password as above'),
              ),*/
            ),
            AppBtn(
              value: "Submit",
              onPressed: () {
                hideKeyboard(context);
                //var request = {"username": "${loginController.text}", "password": "${passwordController.text}"};
                if (!mounted) return;
                setState(() {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    setPassword(widget.userId,oldPasswordController.text, passwordController.text).then((value)async => {

                      if(value.success)
                        {
                          setState(() {
                            isLoading = false;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        homePage(name: widget.name, userId: widget.userId)));
                          })
                        }
                      else{
                        setState(() {
                          isLoading = false;
                          Fluttertoast.showToast(
                              msg: "Failed to change password. Please try again",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        })

                      }
                    }
                    ).catchError((e) {
                      setState(() {
                        isLoading = false;
                      });
                      Fluttertoast.showToast(
                          msg: "Failed to change password. Please try again",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      ;
                    });
                  } else {
                    setState(() {
                      isLoading = false;
                      autoValidate = true;
                    });
                  }
                });
              },
            ).paddingOnly(left: 20, right: 20 , top: 20),
            10.height,
            /*Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Color(0xFFEE3223), borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  // Navigator.push(
                  //     context, MaterialPageRoute(builder: (_) => HomePage()));
                },
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            )*/
            isLoading
                ? Container(
              child: CircularProgressIndicator(),
              alignment: Alignment.center,
            )
                : SizedBox(),
          ],
        ),
      ),
    ),
        onWillPop: _onWillPop);
  }
  Future<bool> _onWillPop() {
    return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) =>
                homePage(name: widget.name, userId: widget.userId)));
  }
}


Future<ForgotPasswordResponse> setPassword(String userId, String oldPassword, String password) async {
  final response = await http.post(
    Uri.https('''', 'api/change-password'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'user_id': userId.trim(),
      'current_password': oldPassword.trim(),
      'new_password': password.trim()

    }),
  );

  log('data1: ' + 'after api call');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    log('data1: ' + response.body);
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return ForgotPasswordResponse.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}