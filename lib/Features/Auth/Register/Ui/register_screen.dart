import 'package:PureFit/Core/Components/custom_button.dart';
import 'package:PureFit/Core/Routing/routes.dart';
import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:PureFit/Features/Auth/Register/Logic/cubit/register_cubit.dart';
import 'package:PureFit/Features/Auth/Register/Ui/regestier_bloc_listner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/Components/custom_sizedbox.dart';
import '../../../../Core/Components/custom_text_field.dart';
import '../../../../Core/Components/media_query.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController userController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassowrdController =
      TextEditingController();
  bool isObscure = true;
  bool isObscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: Form(
        key: formKey,
        child: Column(
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
                  Expanded(
                    flex: 2,
                    child: Text(
                      AppString.createYourAccount(context),
                      style: TextStyle(
                        fontSize: mq.width(7.0),
                        fontWeight: FontWeight.bold,
                        color: theme.scaffoldBackgroundColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(width: mq.width(2.0)),
                  Flexible(
                    child: Image.asset(
                      color: theme.scaffoldBackgroundColor,
                      'assets/images/AppLogo_white.png',
                      height: mq.height(10.0),
                      fit: BoxFit.contain,
                    ),
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
                  // This enables scrolling
                  padding: EdgeInsets.all(mq.width(10.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full Name Field
                      Text(
                        AppString.fullName(context),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: mq.width(5.0),
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomTextField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return AppString.pleaseEnterYourName(context);
                          }
                        },
                        controller: userController,
                        textInput: TextInputType.emailAddress,
                        isPassword: false,
                        hintText: AppString.enterUserName(context),
                        suffixIcon:
                            Icon(Icons.person, color: theme.primaryColor),
                      ),

                      CustomSizedbox(
                        height: mq.height(2.0),
                      ),

                      // Email Field
                      Text(
                        AppString.email(context),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: mq.width(5.0),
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomTextField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return AppString.pleaseEnterEmail(context);
                          } else if (!value.contains('@')) {
                            return AppString.pleaseEnterValidEmail(context);
                          }
                        },
                        controller: emailController,
                        textInput: TextInputType.emailAddress,
                        isPassword: false,
                        hintText: AppString.enterEmail(context),
                        suffixIcon:
                            Icon(Icons.email, color: theme.primaryColor),
                      ),

                      CustomSizedbox(
                        height: mq.height(2.0),
                      ),

                      // Password Field
                      Text(
                        AppString.password(context),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: mq.width(5.0),
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomTextField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return AppString.enterPassword(context);
                            } else if (passwordController
                                    .text.characters.length <
                                8) {
                              return AppString.mustContainAtLeast8CharRegister(
                                  context);
                            }
                          },
                          controller: passwordController,
                          textInput: TextInputType.text,
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

                      CustomSizedbox(height: mq.height(2)),
                      // Confirm Password Field
                      Text(
                        AppString.confirmPassword(context),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: mq.width(5.0),
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CustomTextField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return AppString.confirmPassword(context);
                            } else if (value != passwordController.text) {
                              return AppString.passwordDoesNotMatch(context);
                            }
                          },
                          controller: confirmpassowrdController,
                          textInput: TextInputType.text,
                          isPassword: isObscurePassword,
                          hintText: AppString.confirmPassword(context),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isObscurePassword = !isObscurePassword;
                              });
                            },
                            child: Icon(
                              !isObscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          )),

                      CustomSizedbox(height: mq.height(4)),

                      // Forgot Password Button

                      // Sign Up Button
                      CustomButton(
                        label: AppString.signUp(context),
                        onPressed: () {
                          context.read<RegisterCubit>().password =
                              (passwordController.text);

                          context.read<RegisterCubit>().userEmail =
                              (emailController.text);
                          context.read<RegisterCubit>().userName =
                              (userController.text);
                          validateThenDoSignup(context);
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
                          Text(
                            AppString.alreadyHaveAccount(context),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: theme.textTheme.bodyMedium?.color
                                    ?.withValues(alpha: 0.6),
                                fontFamily: AppString.font),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.loginScreen,
                                (route) => false,
                              );
                            },
                            child: Text(
                              AppString.login(context),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: theme.primaryColor,
                                  fontSize: mq.height(2.0),
                                  fontFamily: AppString.font),
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
      ),
    );
  }

  void validateThenDoSignup(BuildContext context) {
    if (formKey.currentState!.validate()) {
      context.read<RegisterCubit>().doRegister();
    }
  }
}
