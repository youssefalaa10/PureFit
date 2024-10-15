import 'package:fitpro/Features/AuthHelper/cubit/tokencheck_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Core/Routing/Routes.dart';

class TokenCheck extends StatefulWidget {
  const TokenCheck({super.key});

  @override
  State<TokenCheck> createState() => _TokenCheckState();
}

class _TokenCheckState extends State<TokenCheck> {
  @override
  void initState() {
    super.initState();
    // Initiate token check after first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TokencheckCubit>().doTokenCheck();
    });
  }

  // Handle navigation based on the token check result
  void _handleState(BuildContext context, TokencheckState state) {
    if (state is TokencheckSuccessed) {
      _navigateTo(context, Routes.layoutScreen);
    } else if (state is TokencheckFaliuer) {
      _navigateTo(context, Routes.loginScreen);
      // Log the failure or handle error-specific actions
      debugPrint('Token check failed: ${state.message}');
    }
  }

  // General navigation helper function to avoid repeating logic
  void _navigateTo(BuildContext context, String route) {
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<TokencheckCubit, TokencheckState>(
        listener: (context, state) {
          _handleState(context, state); // Handle state changes in one place
        },
        child: BlocBuilder<TokencheckCubit, TokencheckState>(
          buildWhen: (previous, current) =>
              current is TokencheckLoading, // Only rebuild on loading state
          builder: (context, state) {
            if (state is TokencheckLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // If not loading, show empty widget as navigation is handled in listener
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
