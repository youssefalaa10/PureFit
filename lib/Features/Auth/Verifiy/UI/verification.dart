import 'package:fitpro/Core/Components/media_query.dart';
import 'package:fitpro/Core/Routing/routes.dart';
import 'package:flutter/material.dart';

import '../../../../Core/Components/custom_button.dart';
import '../../../../Core/Components/otp_text_field.dart';
import '../../../../Core/Shared/app_colors.dart';

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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: mq.width(5), vertical: mq.height(10)),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Verification",
                  style: TextStyle(
                    fontSize: mq.width(11),
                    color: ColorManager.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: mq.height(2.0)),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "we send code to your email, check it",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: mq.width(4.5),
                    color: ColorManager.lightGreyColor,
                  ),
                ),
              ),
              SizedBox(height: mq.height(5)),
              OtpTextField(
                numberOfFields: 4,
                fieldWidth: 65,
                borderColor: ColorManager.primaryColor,
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
                          title: const Text("Verification Code"),
                          content: Text('Code entered is $verificationCode'),
                        );
                      });
                }, // end onSubmit
              ),
              SizedBox(height: mq.height(5)),
              CustomButton(
                  label: "Continue",
                  padding: EdgeInsets.symmetric(
                    horizontal: mq.width(20),
                    vertical: mq.height(2),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.changePasswordScreen);
                  }),
              SizedBox(height: mq.height(2)),
              TextButton(
                child: Text(
                  "Resend Code",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: mq.width(4.5),
                    color: Colors.black45,
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
