import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitpro/Features/LoginScreen/Data/Model/login_model.dart';
import 'package:fitpro/Features/LoginScreen/Logic/cubit/login_cubit.dart';
import 'package:fitpro/Core/Shared/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool isChecked = false; // Checkbox state
  bool isHoveredEmail = false; // Hover state for email field
  bool isHoveredPassword = false; // Hover state for password field

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Adding listeners to focus nodes to detect focus changes
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
              // Navigate to the next screen (e.g., Home)
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
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Welcome Back, Login To Continue!",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                // Logo Image
                Image.asset(
                  AppString.profile,
                  height: 150,
                ),
                const SizedBox(height: 10),

                // Email textfield with icon and border
                MouseRegion(
                  onEnter: (_) => setState(() => isHoveredEmail = true),
                  onExit: (_) => setState(() => isHoveredEmail = false),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: emailFocusNode.hasFocus || isHoveredEmail
                            ? Colors.purple[800]!
                            : Colors.transparent,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.purple[100],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.purple[800],
                        ),
                        Expanded(
                          child: TextField(
                            controller: emailController,
                            focusNode: emailFocusNode,
                            decoration: const InputDecoration(
                              hintText: "Your Email:",
                              border: InputBorder.none, // Remove default border
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Password textfield with icon and border
                MouseRegion(
                  onEnter: (_) => setState(() => isHoveredPassword = true),
                  onExit: (_) => setState(() => isHoveredPassword = false),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: passwordFocusNode.hasFocus || isHoveredPassword
                            ? Colors.purple[800]!
                            : Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.purple[100],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lock,
                          color: Colors.purple[800],
                          size: 19,
                        ),
                        Expanded(
                          child: TextField(
                            controller: passwordController,
                            focusNode: passwordFocusNode,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Password:",
                              border: InputBorder.none, // Remove default border
                              suffixIcon: Icon(
                                Icons.visibility,
                                color: Colors.purple[900],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Remember me and Forgot Password
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
                        const Text('Remember me'),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // Action for forgot password
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Login Button
                SizedBox(
                  width: double.infinity, // Full width
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
                            content:
                                Text('Please enter both email and password'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primaryColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15), // Adjust height only
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 10,
                      shadowColor: Colors.purple.withOpacity(0.5),
                    ),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Don't have an account?",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity, // Full width
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.purple, // Border color
                        width: 1.5, // Border width
                      ),
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.registerScreen);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.transparent, // Make background transparent
                        padding: const EdgeInsets.symmetric(
                            vertical: 15), // Adjust height only
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Rounded corners
                        ),
                        elevation: 0, // No shadow
                      ),
                      child: const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 20,
                          color:
                              Colors.purple, // Text color to match the border
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
    );
  }
}
