import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:fitpro/Features/Auth/Login/Logic/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/Routing/Routes.dart';


class LoginBlockListener extends StatelessWidget {
  const LoginBlockListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading || state is LoginInitial) {
            showDialog(
              context: context,
              builder: (context) =>  Center(
                child: CircularProgressIndicator(
                  color: ColorManager.primaryColor,
                ),
              ),
            );
          } else if (state is LoginSuccess) {
            Navigator.pop(context);
            Navigator.pushNamed(context, Routes.layoutScreen);
          } else if (state is LoginFaliuer) {
            setupErrorState(context, state.message);
          }
        },
        child: const SizedBox.shrink());
  }

  void setupErrorState(BuildContext context, String error) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.error,
          color: Colors.red,
          size: 32,
        ),
        content: Text(
          error,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Got it',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
