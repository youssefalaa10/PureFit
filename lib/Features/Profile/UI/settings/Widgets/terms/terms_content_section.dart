// Terms Content Section
import 'package:PureFit/Core/Shared/localization/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../../../../Core/Components/media_query.dart';
import 'terms_item.dart';

class TermsContentSection extends StatelessWidget {
  const TermsContentSection({required this.mq, super.key});
  final CustomMQ mq;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TermsItem(
            mq: mq,
            title: 'termsConditionsTitle'.tr(context),
            content: 'termsContent'.tr(context),
          ),
          TermsItem(
            mq: mq,
            title: 'privacyPolicyTitle'.tr(context),
            content: 'termsContent'.tr(context),
          ),
          TermsItem(
            mq: mq,
            title: 'privacyPolicy'.tr(context),
            content: 'termsContent'.tr(context),
          ),
        ],
      ),
    );
  }
}
