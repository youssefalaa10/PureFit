// ignore_for_file: prefer_const_constructors

import 'package:fitpro/Core/Components/custom_button.dart';
import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Components/media_query.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/custom_textfield.dart';
import 'package:fitpro/Features/Auth/Login/Ui/login_screen.dart';
import 'package:fitpro/Features/Auth/Verification/UI/verification_screen.dart';


import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {

    final mq = CustomMQ(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
        elevation: 0,
        backgroundColor: ColorManager.babyBlueColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(mq.height(3.0)),
        
          child: Column(
            children: [
              CustomSizedbox(height: mq.height(5.0)),
              Image.asset(
                "assets/images/Applock.png",
                height: mq.height(16.0),
            
              ),
              CustomSizedbox(height: mq.height(8.0)),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Forgot Password!",
                  style: TextStyle(
                    fontSize: mq.height(4.0),
                    color: ColorManager.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CustomSizedbox(height: mq.height(3.0)),
              Text(
                "Enter your email, we will send you code on your email",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              CustomSizedbox(height: mq.height(3.0)),
              CustomTextField(
                  textInputt: TextInputType.text,
                  isPassword: false,
                  hintTextt: "Enter your email"),
            CustomSizedbox(height: mq.height(3.0)),
              CustomButton(
                  label: "Continue",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VerificationScreen(), // Navigate to VerificationScreen
                      ),
                    );
                  }
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
