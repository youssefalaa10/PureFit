import 'package:PureFit/Core/Components/back_button.dart';
import 'package:PureFit/Core/Components/custom_icon_button.dart';
import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';

class HeaderCalories extends StatelessWidget {
  const HeaderCalories({required this.onPressed, super.key});
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomBackButton(),
          buildHeaderTitle(context),
          _buildEditButton(),
        ],
      ),
    );
  }

  Widget buildHeaderTitle(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          textAlign: TextAlign.center,
          AppString.caloriesDetails(context),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return CustomIconButton(icon: Icons.edit, onPressed: onPressed);
  }
}
