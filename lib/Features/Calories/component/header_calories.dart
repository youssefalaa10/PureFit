import 'package:fitpro/Core/Components/back_button.dart';
import 'package:fitpro/Core/Components/custom_icon_button.dart';
import 'package:flutter/material.dart';

class HeaderCalories extends StatelessWidget {
  final void Function() onPressed;
  const HeaderCalories({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomBackButton(),
          _buildHeaderTitle(),
          _buildEditButton(),
        ],
      ),
    );
  }

  Widget _buildHeaderTitle() {
    return const Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          textAlign: TextAlign.center,
          "Calories Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return CustomIconButton(icon: Icons.edit, onPressed: onPressed);
  }
}
