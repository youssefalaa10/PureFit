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
    final theme = Theme.of(context);
    return TextFormField(
        validator: (value) {
          return validator!(value!);
        },
        controller: controller,
        keyboardType: textInput,
        obscureText: isPassword,
        cursorColor: theme.scaffoldBackgroundColor,
        style: TextStyle(color: theme.scaffoldBackgroundColor),
        
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: theme.scaffoldBackgroundColor),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelStyle: TextStyle(color: theme.scaffoldBackgroundColor),
          focusedBorder:  UnderlineInputBorder(
            borderSide: BorderSide(color: theme.scaffoldBackgroundColor),
          ),
          contentPadding: EdgeInsets.all(mq.width(2.0)),
        ));
  }
}
