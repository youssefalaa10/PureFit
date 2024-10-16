import 'package:flutter/material.dart';

class OtpTextField extends StatefulWidget {
  final int numberOfFields;
  final double fieldWidth;
  final Color borderColor;
  final BorderRadius borderRadius;
  final Color cursorColor;
  final bool showFieldAsBox;
  final ValueChanged<String>? onCodeChanged;
  final ValueChanged<String>? onSubmit;

  const OtpTextField({
    Key? key,
    required this.numberOfFields,
    required this.fieldWidth,
    required this.borderColor,
    required this.borderRadius,
    required this.cursorColor,
    this.showFieldAsBox = false,
    this.onCodeChanged,
    this.onSubmit,
  }) : super(key: key);

  @override
  _OtpTextFieldState createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];
  String currentCode = '';

  @override
  void initState() {
    super.initState();
    controllers = List.generate(widget.numberOfFields, (index) => TextEditingController());
    focusNodes = List.generate(widget.numberOfFields, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void handleTextChanged(String value, int index) {
    currentCode = controllers.map((controller) => controller.text).join();
    if (widget.onCodeChanged != null) {
      widget.onCodeChanged!(currentCode);
    }

    if (value.isNotEmpty && index < widget.numberOfFields - 1) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }

    if (currentCode.length == widget.numberOfFields && widget.onSubmit != null) {
      widget.onSubmit!(currentCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.numberOfFields, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SizedBox(
            width: widget.fieldWidth,
            child: TextField(
              controller: controllers[index],
              focusNode: focusNodes[index],
              cursorColor: widget.cursorColor,
              textAlign: TextAlign.center,
              maxLength: 1,
              decoration: InputDecoration(
                counterText: '',
                border: widget.showFieldAsBox
                    ? OutlineInputBorder(
                        borderRadius: widget.borderRadius,
                        borderSide: BorderSide(color: widget.borderColor),
                      )
                    : UnderlineInputBorder(
                        borderSide: BorderSide(color: widget.borderColor),
                      ),
              ),
              onChanged: (value) => handleTextChanged(value, index),
              keyboardType: TextInputType.number,
            ),
          ),
        );
      }),
    );
  }
}
