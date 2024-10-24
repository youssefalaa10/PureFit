import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';
import 'package:PureFit/Core/Components/media_query.dart';
import 'package:lottie/lottie.dart';
import '../../../Core/Shared/app_colors.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq =
        CustomMQ(context); // Instantiate CustomMQ for responsive calculations

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            datetime(),
            Text(
              AppString.welcomeBack(context),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: mq.width(6), // Use CustomMQ for font size
                fontWeight: FontWeight.bold,
                fontFamily: AppString.font,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorManager.lightGreyColor),
            boxShadow: [
              BoxShadow(
                color: ColorManager.softGreyColor,
                spreadRadius: .3,
                blurRadius: 1,
              ),
            ],
            color: ColorManager.backGroundColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Stack(children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_outlined,
                color: theme.primaryColor,
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

Widget datetime() {
  DateTime now = DateTime.now();
  int hour = now.hour;

  if (hour >= 6 && hour < 12) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Good Morning",
            style: TextStyle(
              fontFamily: AppString.font,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            )),
        const SizedBox(
          width: 5,
        ),
        Lottie.asset('assets/lottie/Morning.json', height: 40, width: 40),
      ],
    );
  } else if (hour >= 12 && hour < 17) {
    return Row(
      children: [
        Text("Good Afternoon",
            style: TextStyle(
              fontFamily: AppString.font,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            )),
        const SizedBox(
          width: 5,
        ),
        Lottie.asset('assets/lottie/Afternon.json', height: 40, width: 40),
      ],
    );
  } else {
    return Row(
      children: [
        Text("Good Evening",
            style: TextStyle(
              fontFamily: AppString.font,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            )),
        const SizedBox(
          width: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child:
              Lottie.asset('assets/lottie/NewMoon.json', height: 40, width: 40),
        ),
      ],
    );
  }
}
