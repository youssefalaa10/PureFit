import 'package:flutter/material.dart';

import 'media_query.dart';

class CustomTextField extends StatelessWidget {
  final TextInputType textInput;
  final bool isPassword;
  final String hintText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;

  const CustomTextField(
      {super.key,
      required this.textInput,
      required this.isPassword,
      required this.hintText,
      this.prefixIcon,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);

    return TextField(
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
