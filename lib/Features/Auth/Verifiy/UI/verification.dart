import 'package:fitpro/Core/Components/custom_snackbar.dart';
import 'package:fitpro/Core/Components/media_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/Components/custom_button.dart';
import '../../../../Core/Components/otp_text_field.dart';
import '../../../../Core/Routing/routes.dart';
import '../../../../Core/Shared/app_colors.dart';
import '../Logic/verifiy_cubit/verification_cubit.dart';
import '../Logic/verifiy_cubit/verification_state.dart';

class VerificationScreen extends StatefulWidget {
  final String email;

  const VerificationScreen({super.key, required this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: mq.width(5),
            vertical: mq.height(10),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: BlocListener<VerificationCubit, VerificationState>(
                      listener: (context, state) {
                        if (state is VerificationLoading) {
                          showDialog(
                            context: context,
                            builder: (context) => const Center(
                                child: CircularProgressIndicator()),
                          );
                        }
                        if (state is VerificationSuccess) {
                          Navigator.pop(context);
                          CustomSnackbar.showSnackbar(context, 'success');
                          Navigator.pushNamed(
                              context, Routes.changePasswordScreen,
                              arguments: widget.email);
                        }
                        if (state is VerificationError) {
                          Navigator.pop(context);
                          CustomSnackbar.showSnackbar(context, state.error);
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Verification",
                            style: TextStyle(
                              fontSize: mq.width(8),
                              color: ColorManager.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: mq.height(2)),
                          Text(
                            "We sent a code to your email, check it.",
                            style: TextStyle(
                              fontSize: mq.width(4.5),
                              color: ColorManager.lightGreyColor,
                            ),
                          ),
                          SizedBox(height: mq.height(5)),
                          OtpTextField(
                            numberOfFields: 4,
                            fieldWidth: mq.width(15),
                            borderColor: ColorManager.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                            cursorColor: ColorManager.primaryColor,
                            showFieldAsBox: true,
                            externalController: _otpController, // Add this line
                            onSubmit: (String verificationCode) {
                              _verifyCode(verificationCode, widget.email);
                            },
                          ),
                          SizedBox(height: mq.height(5)),
                          CustomButton(
                            label: "Continue",
                            padding: EdgeInsets.symmetric(
                              horizontal: mq.width(20),
                              vertical: mq.height(2),
                            ),
                            onPressed: () {
                              if (_otpController.text.length == 4) {
                                _verifyCode(_otpController.text, widget.email);
                              } else {
                                CustomSnackbar.showSnackbar(context,
                                    'Please enter a valid 4-digit code');
                              }
                            },
                          ),
                          SizedBox(height: mq.height(2)),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              child: Text(
                                "Resend Code",
                                style: TextStyle(
                                  fontSize: mq.width(4.5),
                                  color: Colors.black45,
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _verifyCode(String code, String email) {
    if (code.isNotEmpty && code.length == 4) {
      final verificationCubit = context.read<VerificationCubit>();
      verificationCubit.verifyCode(email, code, context);
    } else {
      CustomSnackbar.showSnackbar(context, 'Please enter a valid 4-digit code');
    }
  }
}
