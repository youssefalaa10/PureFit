import 'package:fitpro/Core/Components/custom_snackbar.dart';
import 'package:fitpro/Core/Routing/app_router.dart';
import 'package:fitpro/Core/Shared/routes.dart';
import 'package:flutter/material.dart';

class FitproApp extends StatelessWidget {
  final AppRouter appRouter;
  const FitproApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: CustomSnackbar.scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.checkToken,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
