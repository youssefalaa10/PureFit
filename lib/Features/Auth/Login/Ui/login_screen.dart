import 'package:PureFit/Core/Routing/routes.dart';
import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:PureFit/Features/Auth/Login/Ui/login_block_listener.dart';
import 'package:flutter/material.dart';
import 'package:PureFit/Core/Shared/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:PureFit/Core/Components/media_query.dart';
import '../Data/Model/login_model.dart';
import '../Logic/cubit/login_cubit.dart';
import 'package:PureFit/Core/Components/custom_button.dart';
import 'package:PureFit/Core/Components/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // Header (Hello Sign In and logo)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: mq.width(10.0),
                  vertical: mq.height(9.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hello\nSign In',
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
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(mq.width(15.0)),
                      topRight: Radius.circular(mq.width(15.0)),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(mq.width(10.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a Email!';
                            }
                          },
                          controller: emailController,
                          textInput: TextInputType.emailAddress,
                          isPassword: false,
                          hintText: "Enter your email",
                          suffixIcon: Icon(Icons.email,
                              color: ColorManager.primaryColor),
                        ),
                        SizedBox(height: mq.height(6.0)),

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
                            validator: (value) {
                              if (value.isEmpty) {
                                return AppString.enterPassword(context);
                              }
                            },
                            controller: passwordController,
                            textInput: TextInputType.visiblePassword,
                            isPassword: isObscure,
                            hintText: AppString.enterPassword(context),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },
                              child: Icon(
                                !isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            )),
                        SizedBox(height: mq.height(2)),

                        // Remember me Checkbox
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Remember me Checkbox
                            Row(
                              children: [
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value ?? false;
                                    });
                                  },
                                ),
                                Text(
                                  'Remember me',
                                  style: TextStyle(fontSize: mq.width(4)),
                                ),
                              ],
                            ),
                            // Forgot Password Button
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Routes.forgotPasswordScreen);
                                },
                                child: Text(
                                  AppString.forgotPassword(context),
                                  style:
                                      TextStyle(color: ColorManager.greyColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: mq.height(4)),
                        // Sign In Button
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            label: "Sign In",
                            onPressed: () {
                              validateThenDoSignup(
                                  context,
                                  LoginModel(
                                      userEmail: emailController.text,
                                      userPassword: passwordController.text));
                            },
                            padding:
                                EdgeInsets.symmetric(vertical: mq.height(1)),
                            borderRadius: mq.width(2.5),
                            fontSize: mq.width(5),
                            backgroundColor: theme.primaryColor,
                          ),
                        ),
                        SizedBox(height: mq.height(3)),

                        // Sign Up Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              "Don't have an account?",
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.infoPageView,
                                );
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: ColorManager.primaryColor,
                                  fontSize: mq.height(2.0),
                                ),
                              ),
                            ),
                            const LoginBlockListener()
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validateThenDoSignup(BuildContext context, LoginModel loginmodel) {
    if (formKey.currentState!.validate()) {
      context.read<LoginCubit>().doLogin(loginmodel);
    }
  }
}
