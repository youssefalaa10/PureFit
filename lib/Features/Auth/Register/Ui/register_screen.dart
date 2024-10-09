import 'package:fitpro/Core/Components/custom_button.dart';
import 'package:fitpro/Features/Auth/Register/Logic/cubit/register_cubit.dart';
import 'package:fitpro/Features/Auth/Register/Ui/regestierBlocListner.dart';

import 'package:flutter/material.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/Components/custom_sizedbox.dart';
import '../../../../Core/Components/custom_text_field.dart';
import '../../../../Core/Components/media_query.dart';
import '../../Login/Ui/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController userController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Scaffold(
      backgroundColor: ColorManager.primaryColor,
      body: Column(
        children: [
          // Header (Hello Sign up and logo)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mq.width(10.0),
              vertical: mq.height(9.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Create\nYour Account',
                  style: TextStyle(
                    fontSize: mq.width(7.0),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Image.asset(
                  "assets/images/AppLogo_white.png",
                  height: mq.height(10.0),
                ),
              ],
            ),
          ),

          // Expanded container for form with scroll
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorManager.backGroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(mq.width(15.0)),
                  topRight: Radius.circular(mq.width(15.0)),
                ),
              ),
              child: SingleChildScrollView(
                // This enables scrolling
                padding: EdgeInsets.all(mq.width(10.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomSizedbox(
                      height: mq.height(
                        3,
                      ),
                    ), // Assuming CustomSizedbox is a spacing widget

                    // Full Name Field
                    Text(
                      "Full Name:",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: mq.width(5.0),
                        color: ColorManager.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomTextField(
                      controller: userController,
                      textInput: TextInputType.emailAddress,
                      isPassword: false,
                      hintText: "john smith",
                      suffixIcon:
                          Icon(Icons.person, color: ColorManager.primaryColor),
                    ),

                    CustomSizedbox(
                      height: mq.height(2.0),
                    ),

                    // Email Field
                    Text(
                      "Email:",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: mq.width(5.0),
                        color: ColorManager.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomTextField(
                      controller: emailController,
                      textInput: TextInputType.emailAddress,
                      isPassword: false,
                      hintText: "john@email.com",
                      suffixIcon:
                          Icon(Icons.email, color: ColorManager.primaryColor),
                    ),

                    CustomSizedbox(
                      height: mq.height(2.0),
                    ),

                    // Password Field
                    Text(
                      "Password:",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: mq.width(5.0),
                        color: ColorManager.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomTextField(
                      controller: passwordController,
                      textInput: TextInputType.number,
                      isPassword: true,
                      hintText: "*********",
                      suffixIcon:
                          Icon(Icons.lock, color: ColorManager.primaryColor),
                    ),

                    CustomSizedbox(height: mq.height(2)),
                    // Confirm Password Field
                    Text(
                      "Confirm Password:",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: mq.width(5.0),
                        color: ColorManager.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomTextField(
                      controller: passwordController,
                      textInput: TextInputType.number,
                      isPassword: true,
                      hintText: "*********",
                      suffixIcon:
                          Icon(Icons.lock, color: ColorManager.primaryColor),
                    ),

                    CustomSizedbox(height: mq.height(4)),

                    // Forgot Password Button

                    // Sign Up Button
                    CustomButton(
                      label: "Sign Up",
                      onPressed: () {
                        context
                            .read<RegisterCubit>()
                            .updatePassword(passwordController.text);
                        context
                            .read<RegisterCubit>()
                            .updateUserEmail(emailController.text);
                        context
                            .read<RegisterCubit>()
                            .updateUserName(userController.text);

                        context.read<RegisterCubit>().doRegister();
                      },
                      fontSize: mq.width(5.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                    ),

                    CustomSizedbox(height: mq.height(3)),

                    // Sign In  Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "Already have account",
                          textAlign: TextAlign.right,
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Login',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: ColorManager.primaryColor,
                              fontSize: mq.height(2.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const RegisterBlocListener()
        ],
      ),
    );
  }
}
