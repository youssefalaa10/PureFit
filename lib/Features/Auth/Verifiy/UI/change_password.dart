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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: 100,
              ),
              const SizedBox(height: 20),
              Text(
                "Change Password!",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 35,
                  color:ColorManager.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
               Text(
                "Enter your new password",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  color: ColorManager.lightGreyColor,
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                  controller: _codeNumberController,
                  textInput: TextInputType.number,
                  isPassword: true,
                  hintText: "Enter your new password"),
              const SizedBox(height: 20),
              CustomTextField(
                  controller: _confirmCodeController,
                  textInput: TextInputType.number,
                  isPassword: true,
                  hintText: "Confirm your new password"),
              const SizedBox(height: 20),
              CustomButton(label: "Continue", onPressed: (){}),
            ],
          ),
        ),
      ),
    );
  }
}
