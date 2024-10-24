import 'package:flutter/material.dart';

import 'media_query.dart';

class CustomTextField extends StatelessWidget {
  final TextInputType? textInput;
  final bool isPassword;
  final String hintText;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? validator;
  final TextEditingController? controller;
  const CustomTextField(
      {super.key,
      this.textInput,
      required this.isPassword,
      required this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      required this.controller,
      this.validator});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return TextFormField(
        validator: (value) {
          return validator!(value!);
        },
        controller: controller,
        keyboardType: textInput,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelStyle: const TextStyle(color: Colors.grey),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          contentPadding: EdgeInsets.all(mq.width(2.0)),
        ));
  }
}
