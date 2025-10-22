import 'package:flutter/material.dart';

import 'media_query.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {required this.isPassword,
      required this.hintText,
      required this.controller,
      super.key,
      this.textInput,
      this.prefixIcon,
      this.suffixIcon,
      this.validator});
  final TextInputType? textInput;
  final bool isPassword;
  final String hintText;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final Function? validator;
  final TextEditingController? controller;

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
