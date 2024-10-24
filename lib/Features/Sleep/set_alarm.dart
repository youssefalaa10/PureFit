import 'package:PureFit/Core/Components/back_button.dart';
import 'package:PureFit/Core/Components/custom_icon_button.dart';
import 'package:PureFit/Core/Components/media_query.dart';
import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:PureFit/Features/Sleep/Components/alarm_item.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class SetAlarm extends StatelessWidget {
  const SetAlarm({super.key});

  @override
  Widget build(BuildContext context) {
    CustomMQ mq = CustomMQ(context);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(mq, theme),
              SizedBox(
                height: mq.height(2),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
                child: Text(
                  AppString.setNewAlarm(context),
                  style: TextStyle(
                      color: theme.primaryColor,
                      fontFamily: AppString.font,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: mq.height(2),
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (cont, index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Alarmitem(),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(CustomMQ mq, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomBackButton(),
          _buildHeaderTitle(mq, theme,context),
          CustomIconButton(icon: Icons.close, onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildHeaderTitle(CustomMQ mq, ThemeData theme,context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.width(7.5)),
        child: Text(
          AppString.sleep(context),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: theme.primaryColor,
            fontFamily: AppString.font,
            fontSize: mq.width(4.5),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
