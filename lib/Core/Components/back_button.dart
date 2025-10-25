import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.iconColor});
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
     final theme = Theme.of(context);
    return IconButton(
      icon:  Icon(
        Icons.arrow_back,
        color: iconColor ?? theme.scaffoldBackgroundColor,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
      padding: EdgeInsets.zero,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
    );
  }
}
