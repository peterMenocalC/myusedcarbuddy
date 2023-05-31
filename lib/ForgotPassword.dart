import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_mucb/ResetCode.dart';
import 'package:flutter_app_mucb/model/ForgotPasswordResponse.dart';
import 'package:flutter_app_mucb/model/InspectionOptionsData.dart';
import 'package:flutter_app_mucb/utils/EmailValidator.dart';
import 'package:flutter_app_mucb/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;


class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  var autoValidate = false;
  final loginController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Image.asset('asset/images/app_logo.png',width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,),
                )),
            /*Padding(
              padding: const EdgeInsets.only(top: 150.0),
              child: Center(
                child: Container(
                    height: 60,
                    *//*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*//*
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(color: Colors.black, fontSize: 35),
                    )),
              ),
            ),*/
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Enter your email and a password reset code will be sent to your email',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),20.height,
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                  EditText(
                  hintText: "Enter Email Id*",
                  isPassword: false,
                  mController: loginController,
                  mKeyboardType: TextInputType.emailAddress,
                  validator: (String s) {
                    if (s.trim().isEmpty) return "Email Id" + " " + "Field Required";
                    if (!EmailValidator.validate(s)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
                14.height,
                  ],
                ),
            ),
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
                    forgotPassword(loginController.text).then((value)async => {

                      if(value.success)
                        {
                        setState(() {
                      isLoading = false;
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (_) =>
                          ResetCode(email: loginController.text)));
                    })
                        }
                      else{
                        setState(() {
                      isLoading = false;
                      Fluttertoast.showToast(
                          msg: "Invalid Email id",
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
                          msg: "Invalid Email id",
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
                   Navigator.push(
                       context, MaterialPageRoute(builder: (_) => ResetCode()));
                },
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),*/
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Color(0xffF8A27F), fontSize: 15),
              ),
            ),
            isLoading
                ? Container(
              child: CircularProgressIndicator(),
              alignment: Alignment.center,
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
Future<ForgotPasswordResponse> forgotPassword(String email) async {
  final response = await http.post(
    Uri.https('''', 'api/forget-password'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email.trim(),
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

