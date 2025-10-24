import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
    this.borderRadius = 30.0,
    this.fontSize = 16.0,
    this.textColor,
  });
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final double borderRadius;
  final double fontSize;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.001,
          horizontal: MediaQuery.of(context).size.width * 0.07),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? theme.primaryColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: AppString.font,
            fontSize: fontSize,
            color: textColor ?? theme.scaffoldBackgroundColor,
          ),
        ),
      ),
    );
  }
}
