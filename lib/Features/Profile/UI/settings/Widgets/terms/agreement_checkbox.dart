import 'package:flutter/material.dart';

import '../../../../../../Core/Components/media_query.dart';

class AgreementCheckbox extends StatefulWidget {
  final CustomMQ mq;
  final String label;

  const AgreementCheckbox({super.key, required this.mq, required this.label});

  @override
  AgreementCheckboxState createState() => AgreementCheckboxState();
}

class AgreementCheckboxState extends State<AgreementCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value ?? false;
            });
          },
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: widget.mq.width(3.5),
            ),
          ),
        ),
      ],
    );
  }
}
