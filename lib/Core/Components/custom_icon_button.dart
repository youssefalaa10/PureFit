import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    required this.icon,
    required this.onPressed,
    super.key,
    this.iconColor = Colors.black,
  });
  final IconData icon;
  final VoidCallback onPressed;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextButton(
        style: TextButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(10.0),
        ),
        onPressed: onPressed,
        child: Icon(icon, size: 25, color: iconColor),
      ),
    );
  }
}
