import 'package:fitpro/Core/Routing/app_router.dart';
import 'package:fitpro/Core/Shared/Routes.dart';
import 'package:flutter/material.dart';

class FitproApp extends StatelessWidget {
  final AppRouter appRouter;
  const FitproApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.userGenderScreen,
      onGenerateRoute: appRouter.generateRoute,
    );
  }
}
