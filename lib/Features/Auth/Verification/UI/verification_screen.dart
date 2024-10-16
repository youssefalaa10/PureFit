// ignore_for_file: prefer_const_constructors

import 'package:fitpro/Core/Components/custom_button.dart';
import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Components/media_query.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Features/Auth/ChangePassword/UI/change_password.dart';

import 'package:fitpro/Features/Auth/ForgotPassword/UI/forgot_password.dart';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';


class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Verification"),
        elevation: 0,
        backgroundColor: ColorManager.babyBlueColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              CustomSizedbox(height: mq.height(5.0)),
              Image.asset(
              "assets/images/AppEmail.png",
                height: mq.height(16.0),
              ),
              CustomSizedbox(height: mq.height(8.0)),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Verification",
                  style: TextStyle(
                    fontSize: mq.height(4.0),
                    color: ColorManager.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CustomSizedbox(height: mq.height(3.0)),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "we send code to your email, check it",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              CustomSizedbox(height: mq.height(3.0)),
              OtpTextField(
                numberOfFields: 5,
                fieldWidth: mq.width(15.0),
                borderColor: ColorManager.blackColor,
                borderRadius: BorderRadius.circular(20),
                cursorColor: ColorManager.primaryColor,
                //set to true to show as box or false to show as dash
                showFieldAsBox: true,
                //runs when a code is typed in
                onCodeChanged: (String code) {
                  //handle validation or checks here
                },
                //runs when every textfield is filled
                onSubmit: (String verificationCode) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Verification Code"),
                          content: Text('Code entered is $verificationCode'),
                        );
                      });
                }, // end onSubmit
              ),
            
              CustomSizedbox(height: mq.height(3.0)),
              CustomButton(
                  label: "Continue",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChangePasswordScreen(), // Navigate to Change Password screen
                      ),
                    );
                  }),
              

            
              /*
                  Text(
                    "Resend Code",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black45,
                    ),
                  ),
                  */
            ],
          ),
        ),
      ),
    );
  }
}
