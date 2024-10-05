import 'package:flutter/material.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitpro/Core/Shared/routes.dart';
import 'package:fitpro/Core/Components/media_query.dart'; // Import CustomMQ

import '../Data/Model/login_model.dart';
import '../Logic/cubit/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  bool isHoveredEmail = false;
  bool isHoveredPassword = false;

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    emailFocusNode.addListener(() {
      setState(() {});
    });

    passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Scaffold(
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
          child: Container(
            padding: EdgeInsets.all(mq.width(5)),
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Welcome Back, Login To Continue!",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: mq.width(6),
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: mq.height(2)),
                  Image.asset(
                    AppString.profile,
                    height: mq.height(20),
                  ),
                  SizedBox(height: mq.height(2)),
                  MouseRegion(
                    onEnter: (_) => setState(() => isHoveredEmail = true),
                    onExit: (_) => setState(() => isHoveredEmail = false),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorManager.blackColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(mq.width(2.5)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: mq.width(2.5)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: mq.width(5),
                          ),
                          Expanded(
                            child: TextField(
                              controller: emailController,
                              focusNode: emailFocusNode,
                              decoration: const InputDecoration(
                                hintText: "Your Email:",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: mq.height(2)),
                  MouseRegion(
                    onEnter: (_) => setState(() => isHoveredPassword = true),
                    onExit: (_) => setState(() => isHoveredPassword = false),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorManager.blackColor,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(mq.width(2.5)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: mq.width(2.5)),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock,
                            size: mq.width(5),
                          ),
                          Expanded(
                            child: TextField(
                              controller: passwordController,
                              focusNode: passwordFocusNode,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Password:",
                                border: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.visibility,
                                  size: mq.width(5),
                                  color: Colors.purple[900],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: mq.height(2)),
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
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey, fontSize: mq.width(4)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: mq.height(2)),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final String email = emailController.text.trim();
                        final String password = passwordController.text.trim();
              
                        if (email.isNotEmpty && password.isNotEmpty) {
                          final loginModel = LoginModel(
                            userEmail: email,
                            userPassword: password,
                          );
                          context.read<LoginCubit>().doLogin(loginModel);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter both email and password'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: mq.height(2)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(mq.width(2.5)),
                        ),
                        elevation: 10,
                        shadowColor: Colors.purple.withOpacity(0.5),
                      ),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: mq.width(5),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: mq.height(2)),
                  Text(
                    "Don't have an account?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: mq.width(4),
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: mq.height(2)),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.purple,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(mq.width(4)),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.registerScreen);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(vertical: mq.height(2)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(mq.width(4)),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: mq.width(5),
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
