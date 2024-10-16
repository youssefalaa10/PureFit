import 'package:fitpro/Features/Auth/Verifiy/UI/verification.dart';
import 'package:flutter/material.dart';

import '../../../../Core/Components/custom_button.dart';
import '../../../../Core/Components/custom_text_field.dart';
import '../../../../Core/Shared/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        elevation: 0,
      ),
      body: Container(
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
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Forgot Password!",
                style: TextStyle(
                  fontSize: 35,
                  color: ColorManager.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Enter your email, we will send you code on your email",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                color: ColorManager.lightGreyColor,
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
                controller: _emailController,
                textInput: TextInputType.text,
                isPassword: false,
                hintText: "Enter your email"),
            const SizedBox(height: 20),
            CustomButton(
              label: "Continue",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const VerificationScreen(), // Navigate to VerificationScreen
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
