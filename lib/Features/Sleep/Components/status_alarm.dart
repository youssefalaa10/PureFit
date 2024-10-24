import 'package:PureFit/Core/Shared/app_colors.dart';
import 'package:flutter/material.dart';

class StatusAlarm extends StatelessWidget {
  final String label;
  final String trailing;

  const StatusAlarm({super.key, required this.label, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selectedColor: ColorManager.babyBlueColor,
      shape: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorManager.lightGreyColor)),
      title: Text(
        label,
        style: const TextStyle(fontSize: 18),
      ),
      trailing: Text(
        trailing,
        style: TextStyle(fontSize: 13, color: ColorManager.greyColor),
      ),
    );
  }
}
