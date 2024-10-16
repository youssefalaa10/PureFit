// ignore_for_file: prefer_const_constructors
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextInputType textInputt;
  final bool isPassword;
  final String hintTextt;
  final Icon? prefixIcon;
  final Icon? suffixIcon;

  CustomTextField(
      {Key? key,
      required this.textInputt,
      required this.isPassword,
      required this.hintTextt,
      this.prefixIcon,
      this.suffixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
        keyboardType: textInputt,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintTextt,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          // To delete borders
            enabledBorder: OutlineInputBorder(
            borderSide: Divider.createBorderSide(context),
              borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorManager.primaryColor,
            ),
          ),
          fillColor: ColorManager.babyBlueColor,
          filled: true,
          contentPadding: const EdgeInsets.all(8.0),
        ));
  }
}
