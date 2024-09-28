import 'package:fitpro/Core/DI/dependency.dart';
import 'package:fitpro/Core/Routing/app_router.dart';
import 'package:fitpro/fitpro_app.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpGit();
  runApp(FitproApp(appRouter: AppRouter()));
}
