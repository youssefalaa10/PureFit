
import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:PureFit/Core/Shared/localization/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../Core/Components/media_query.dart';
import 'Widgets/terms/agreement_checkbox.dart';
import 'Widgets/terms/terms_content_section.dart';
import 'Widgets/terms/terms_header_section.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = CustomMQ(context);
    final theme = Theme.of(context);
    return Scaffold(
      
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: mq.width(5)),
        child: Column(
          children: [
            SizedBox(height: mq.height(5)),
            HeaderSection(mq: mq),
            SizedBox(height: mq.height(3)),
            Expanded(child: TermsContentSection(mq: mq)),
            SizedBox(height: mq.height(2)),
            AgreementSection(mq: mq),
            SizedBox(height: mq.height(3)),
            ActionButtonsSection(mq: mq),
            SizedBox(height: mq.height(3)),
          ],
        ),
      ),
    );
  }
}
class AgreementSection extends StatelessWidget {
  final CustomMQ mq;

  const AgreementSection({super.key, required this.mq});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AgreementCheckbox(mq: mq, label: 'agreeTerms'.tr(context)),
        AgreementCheckbox(mq: mq, label: 'agreePrivacy'.tr(context)),
      ],
    );
  }
}


// Action Buttons Section
class ActionButtonsSection extends StatelessWidget {
  final CustomMQ mq;

  const ActionButtonsSection({super.key, required this.mq});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
      
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,

            padding: EdgeInsets.symmetric(
              horizontal: mq.width(10),
              vertical: mq.height(2),
            ),
          ),
          onPressed: () {},
          child: Text(
            AppString.accept(context),
            style: TextStyle(fontSize: mq.width(3.5), color: Theme.of(context).scaffoldBackgroundColor),
          ),
        ),
      ],
    );
  }
}