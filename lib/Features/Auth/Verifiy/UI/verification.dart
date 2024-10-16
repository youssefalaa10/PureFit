import 'package:fitpro/Features/Auth/Verifiy/UI/change_password.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Password"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: 200,
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Verification",
                  style: TextStyle(
                    fontSize: 35,
                    color:ColorManager.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "we send code to your email, check it",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    color: ColorManager.lightGreyColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              OtpTextField(
                numberOfFields: 5,
                fieldWidth: 65,
                borderColor: const Color(0xFF512DA8),
                borderRadius: BorderRadius.circular(20),
                cursorColor: Colors.purple,
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
              const SizedBox(height: 20),
              CustomButton(
                  label: "Continue",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const ChangePasswordScreen(), // Navigate to ChangePasswordScreen
                      ),
                    );
                  }),
              const SizedBox(height: 20),
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
