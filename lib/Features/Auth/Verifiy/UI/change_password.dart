import 'package:fitpro/Core/Components/media_query.dart';
import 'package:flutter/material.dart';

import '../../../../Core/Components/custom_button.dart';
import '../../../../Core/Components/custom_text_field.dart';
import '../../../../Core/Shared/app_colors.dart';


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
final TextEditingController _codeNumberController = TextEditingController();
final TextEditingController _confirmCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final mq=CustomMQ(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding:  EdgeInsets.symmetric(vertical: mq.height(10),horizontal: mq.width(5)),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Change Password!",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: mq.width(10),
                  color:ColorManager.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
               SizedBox(height: mq.height(2)),
               Text(
                "Enter your new password",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: mq.height(3),
                  color: ColorManager.lightGreyColor,
                ),
              ),
               SizedBox(height: mq.height(3)),
              CustomTextField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a password!';
                    }
                  },
                  controller: _codeNumberController,
                  textInput: TextInputType.number,
                  isPassword: true,
                  hintText: "Enter your new password"),
               SizedBox(height: mq.height(3)),
              CustomTextField(
                  controller: _confirmCodeController,
                  textInput: TextInputType.number,
                  isPassword: true,
                  hintText: "Confirm your new password"),
               SizedBox(height: mq.height(3)),
              CustomButton(label: "Continue", onPressed: (){},    padding: EdgeInsets.symmetric(
                    horizontal: mq.width(20),
                    vertical: mq.height(2),
                  ),),
            ],
          ),
        ),
      ),
    );
  }
}
