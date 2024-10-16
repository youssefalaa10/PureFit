// ignore_for_file: prefer_const_constructors

import 'package:fitpro/Core/Components/custom_button.dart';
import 'package:fitpro/Core/Components/custom_sizedbox.dart';
import 'package:fitpro/Core/Shared/custom_textfield.dart';

import 'package:fitpro/Core/Components/media_query.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Features/Auth/Verification/UI/verification_screen.dart';

import 'package:fitpro/Features/Home/home_screen.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
        elevation: 0,
        backgroundColor: ColorManager.babyBlueColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VerificationScreen()),
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
                "assets/images/AppLogo.png",
                height: mq.height(16.0),
              ),
              CustomSizedbox(height: mq.height(8.0)),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Change Password",
                  style: TextStyle(
                    fontSize: mq.height(4.0),
                    color: ColorManager.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CustomSizedbox(height: mq.height(3.0)),
              Text(
                "Enter your new Password",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              CustomSizedbox(height: mq.height(3.0)),
              CustomTextField(
                  textInputt: TextInputType.number,
                  isPassword: false,
                  hintTextt: "Enter your new password"),
              CustomSizedbox(height: mq.height(3.0)),
              CustomTextField(
                  textInputt: TextInputType.number,
                  isPassword: false,
                  hintTextt: "Confirm your new password"),
              CustomSizedbox(height: mq.height(3.0)),
              CustomButton(
                  label: "Continue",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HomeScreen(), // Navigate to VerificationScreen
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
