import 'package:fitpro/Core/Component/custom_snackbar.dart';
import 'package:fitpro/Core/Networking/DioAuthApi/dio_auth_api.dart';
import 'package:flutter/material.dart';

class Loginprototyp extends StatelessWidget {
  const Loginprototyp({super.key});

  @override
  Widget build(BuildContext context) {
    final api = DioAuthApi();
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  final bool result =
                      await api.dioLogin("Mohamed@gmail.com", "12345678");
                  CustomSnackbar.showSnackbar(context, "$result");
                },
                child: const Text("Login")),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  final bool result = await api.dioRegister(
                      email: 'Mohamed1@gmail.com',
                      password: "12345678",
                      userName: 'sadasd',
                      age: 0,
                      height: 0,
                      weight: 0,
                      gender: '');
                  CustomSnackbar.showSnackbar(context, "$result");
                },
                child: Text("Register"))
          ],
        ),
      ),
    );
  }
}
