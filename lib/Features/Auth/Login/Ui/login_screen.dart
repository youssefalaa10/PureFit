import 'package:flutter/material.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitpro/Core/Components/media_query.dart';
import 'package:fitpro/Core/Shared/routes.dart';
import '../Data/Model/login_model.dart';
import '../Logic/cubit/login_cubit.dart';
import 'package:fitpro/Core/Components/custom_button.dart';
import 'package:fitpro/Core/Components/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Scaffold(
      backgroundColor: ColorManager.primaryColor,
      body: SafeArea(
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logging in...'),
                  duration: Duration(seconds: 2),
                ),
              );
            } else if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Login Successful!'),
                  duration: Duration(seconds: 2),
                ),
              );
              Navigator.pushNamed(context, Routes.layoutScreen);
            } else if (state is LoginFaliuer) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
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
                    color: ColorManager
                        .backGroundColor, // White background for the form
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
                          textInput: TextInputType.emailAddress,
                          isPassword: false,
                          hintText: "john@email.com",
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
                          textInput: TextInputType.visiblePassword,
                          isPassword: true,
                          hintText: "*********",
                          suffixIcon: Icon(Icons.lock,
                              color: ColorManager.primaryColor),
                        ),
                        SizedBox(height: mq.height(2)),

                        // Remember me Checkbox
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                            TextButton(
                              onPressed: () {
                                // Forgot password action
                              },
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(color: ColorManager.greyColor),
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
                              final String email = emailController.text.trim();
                              final String password =
                                  passwordController.text.trim();

                              if (email.isNotEmpty && password.isNotEmpty) {
                                final loginModel = LoginModel(
                                  userEmail: email,
                                  userPassword: password,
                                );
                                context.read<LoginCubit>().doLogin(loginModel);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please enter both email and password'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            padding:
                                EdgeInsets.symmetric(vertical: mq.height(1)),
                            borderRadius: mq.width(2.5),
                            fontSize: mq.width(5),
                            backgroundColor: ColorManager.primaryColor,
                            textColor: Colors.white,
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
                                    context, Routes.registerScreen);
                              },
                              child: Text(
                                'Sign Up',
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
            ],
          ),
        ),
      ),
    );
  }
}
