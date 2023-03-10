import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kimber/functions/userApiCalls.dart';
import 'package:kimber/models/userModel.dart';
import 'package:kimber/screens/authentication/pickProfilePictureScreen.dart';
import 'package:kimber/utils/colors.dart';
import 'package:kimber/utils/utils.dart';
import 'package:kimber/widgets/inputField.dart';
import 'package:sizer/sizer.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _globalFormKey = GlobalKey();

  String username = "";
  String email = "";
  String password = "";
  bool loading = false;

  UserApiCalls userApiCalls = UserApiCalls();

  signUpUser(String username, String email, String password) async {
    setState(() {
      loading = true;
    });
    var newUser = await userApiCalls.registerUser(username, email, password);
    if (newUser != null) {
      setState(() {
        loading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PickProfilePictureScreen(
                  userId: newUser.userId,
                )),
      );
      print("Success");
    } else {
      setState(() {
        loading = false;
      });
      showSnackBar("Something went wrong", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 3.h, left: 5.w),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      'Hello ',
                      style: TextStyle(
                        fontSize: 32.sp,
                        color: greyishWhite,
                      ),
                    ),
                   Image.asset(
                     'assets/icons/hello.png',
                   height: 6.h,)
                  ],
                )),
            Container(
              margin: EdgeInsets.only(left: 5.w),
              alignment: Alignment.centerLeft,
              child: Text("Please enter your details to continue",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: greyishWhite,
                ),),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 3.5.h,
                      ),

                      Form(
                          key: _globalFormKey,
                          child: Column(
                            children: [
                              //Username
                              InputField(
                                controller: usernameController,
                                fieldType: 'Username',
                              ),

                              //Email
                              InputField(
                                controller: emailController,
                                fieldType: 'Email ID',
                              ),

                              //Password
                              InputField(
                                controller: passwordController,
                                fieldType: 'Password',
                                isObscure: true,
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 5.h,
                      )
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                if (_globalFormKey.currentState!.validate()) {
                  print(usernameController.text);
                  print(emailController.text);
                  signUpUser(usernameController.text, emailController.text,
                      passwordController.text);
                }
              },
              child: Container(
                height: 6.h,
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 3.h, left: 8.w, right: 8.w),
                decoration: BoxDecoration(
                    color: greenAccent, borderRadius: BorderRadius.circular(50)),
                child: loading
                    ? Container(
                        height: 2.2.h,
                        width: 2.2.h,
                        child: const CircularProgressIndicator(
                          color: darkblue,
                          strokeWidth: 3.0,
                        ),
                      )
                    : Text(
                        'Continue',
                        style:
                            TextStyle(color: darkblue, fontSize: 16.sp),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
