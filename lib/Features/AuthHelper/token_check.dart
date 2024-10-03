import 'package:fitpro/Features/AuthHelper/cubit/tokencheck_cubit.dart';
import 'package:fitpro/Core/Shared/Routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TokenCheck extends StatefulWidget {
  const TokenCheck({super.key});

  @override
  State<TokenCheck> createState() => _TokenCheckState();
}

class _TokenCheckState extends State<TokenCheck> {
  @override
  void initState() {
    super.initState();
    // Initiate token check when widget is created
    context.read<TokencheckCubit>().doTokenCheck();
  }

  void _navigateTo(BuildContext context, String route) {
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TokencheckCubit, TokencheckState>(
      listener: (context, state) {
        if (state is TokencheckSuccessed) {
          // Navigate to the layout screen when the token check succeeds
          _navigateTo(context, Routes.layoutScreen);
        } else if (state is TokencheckFaliuer) {
          // Navigate to the login screen when token check fails
          _navigateTo(context, Routes.loginScreen);
        }
      },
      child: BlocBuilder<TokencheckCubit, TokencheckState>(
        builder: (context, state) {
          if (state is TokencheckLoading) {
            // Show loading indicator while token check is in progress
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TokencheckFaliuer) {
            // Optionally show an error message if the token check fails
            return const Center(
              child: Text('Token check failed. Redirecting to login...'),
            );
          }
          // Return an empty widget if no state matches (handled by BlocListener)
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
