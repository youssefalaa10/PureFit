import 'package:PureFit/Core/Components/custom_snackbar.dart';
import 'package:PureFit/Core/Shared/app_colors.dart';
import 'package:PureFit/Features/Auth/Register/Logic/cubit/register_cubit.dart';
import 'package:PureFit/Features/Auth/Register/Logic/cubit/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/Routing/routes.dart';

class RegisterBlocListener extends StatelessWidget {
  const RegisterBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterInitial || state is RegisterLoading) {
          showDialog(
            context: context,
            builder: (context) => Center(
              child: CircularProgressIndicator(
                color: ColorManager.primaryColor,
              ),
            ),
          );
        } else if (state is RegisterSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.layoutScreen,
            (route) => false,
          );
          showSuccessDialog(context);
        } else if (state is RegisterFailure) {
          setupErrorState(context, state.message);
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Signup Successful'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Congratulations, you have signed up successfully!'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              disabledForegroundColor: Colors.grey.withOpacity(0.38),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Continue'),
          ),
        ],
      );
    },
  );
}

void setupErrorState(BuildContext context, String error) {
  Navigator.pop(context);
  CustomSnackbar.showSnackbar(context, error.toString());
}
