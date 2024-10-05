import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  bool isHoveredEmail = false; // Hover state for email field
  bool isHoveredPassword = false; // Hover state for password field
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Let's get started",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Join our community and discover a healthier, stronger you!",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Image.asset(
                "assets/images/logo.png",
                height: 100,
              ),

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
                      Expanded(
                        child: TextField(
                          focusNode: emailFocusNode,
                          decoration: const InputDecoration(
                            hintText: "Name:",
                            border: InputBorder.none, // Remove default border
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

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
                      Expanded(
                        child: TextField(
                          focusNode: emailFocusNode,
                          decoration: const InputDecoration(
                            hintText: "Email:",
                            border: InputBorder.none, // Remove default border
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

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
                      Expanded(
                        child: TextField(
                          focusNode: emailFocusNode,
                          decoration: const InputDecoration(
                            hintText: "Password:",
                            border: InputBorder.none, // Remove default border
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

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
                      Expanded(
                        child: TextField(
                          focusNode: emailFocusNode,
                          decoration: const InputDecoration(
                            hintText: "Re-type password:",
                            border: InputBorder.none, // Remove default border
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 20),
              // Register Button
              SizedBox(
                width: double.infinity, // Full width
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15), // Adjust height only
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 10,
                    shadowColor: Colors.purple.withOpacity(0.5),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    ' Sign In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.primaryColor,
                      decoration: TextDecoration.underline,
                      decorationColor: ColorManager.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
