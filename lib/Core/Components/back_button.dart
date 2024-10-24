import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.iconColor});
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // with background------------------
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   border: Border.all(color: ColorManager.greyColor.withOpacity(0.5)),
      //   borderRadius: BorderRadius.circular(50),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.2),
      //       spreadRadius: 2,
      //       blurRadius: 5,
      //       offset: const Offset(0, 3),
      //     ),
      //   ],
      // ),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        padding: EdgeInsets.zero,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
    );
  }
}
