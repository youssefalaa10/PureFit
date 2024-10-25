import 'package:PureFit/Core/Components/media_query.dart';
import 'package:PureFit/Core/Routing/routes.dart';
import 'package:PureFit/Core/Shared/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Components/custom_button.dart';
import '../../../../Core/Components/custom_snackbar.dart';
import '../../../../Core/Components/custom_text_field.dart';
import '../../../../Core/Shared/app_colors.dart';
import '../../../../Core/Shared/app_string.dart';
import '../Logic/forgot_pass_cubit/forgot_password_cubit.dart';
import '../Logic/forgot_pass_cubit/forgot_password_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        padding: EdgeInsets.symmetric(
            vertical: mq.height(10), horizontal: mq.width(5)),
        width: double.infinity,
        height: double.infinity,
        child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordLoading) {
              showDialog(
                context: context,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (state is ForgotPasswordSuccess) {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                Routes.verificationScreen,
                arguments: _emailController.text,
              );
            }
            if (state is ForgotPasswordError) {
              Navigator.pop(context);
              CustomSnackbar.showSnackbar(context, state.error);
            }
          },
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppString.forgotPassword(context),
                    style: TextStyle(
                      fontSize: mq.width(10),
                      color: ColorManager.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppString.font,
                    ),
                  ),
                ),
                SizedBox(height: mq.width(4)),
                Text(
                  AppString.enterYourEmail(context),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: mq.width(4),
                    color: ColorManager.lightGreyColor,
                  ),
                ),
                SizedBox(height: mq.width(4)),
                CustomTextField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return AppString.enterYourEmail(context);
                    } else if (!value.contains("@")) {
                      return AppString.pleaseEnterAValidEmail(context);
                    }
                  },
                  controller: _emailController,
                  textInput: TextInputType.text,
                  isPassword: false,
                  hintText: "Enter your email",
                  suffixIcon:
                      Icon(Icons.email, color: ColorManager.primaryColor),
                ),
                SizedBox(height: mq.width(4)),
                CustomButton(
                  textColor: theme.primaryColor,
                  backgroundColor: theme.scaffoldBackgroundColor,
                  label: "continue".tr(context),
                  padding: EdgeInsets.symmetric(
                    horizontal: mq.width(20),
                    vertical: mq.height(2),
                  ),
                  onPressed: () {
                    validateThenDoForgotPassword(
                      context,
                      _emailController.text,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validateThenDoForgotPassword(BuildContext context, String email) {
    if (formKey.currentState!.validate()) {
      context.read<ForgotPasswordCubit>().sendCode(email);
    }
  }
}
