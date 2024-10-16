import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final double borderRadius;
  final double fontSize;
  final Color textColor;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    this.borderRadius = 30.0,
    this.fontSize = 20.0,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? ColorManager.primaryColor,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor,
            ),
          ),
        ),
  
    );
  }
}
