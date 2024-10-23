import 'package:fitpro/Core/Components/custom_text_field.dart';
import 'package:fitpro/Core/Shared/app_colors.dart';
import 'package:flutter/material.dart';

class ScaleTransitionDialog extends StatefulWidget {
  final Function(String)? onPressed;
  final String itemName;
  const ScaleTransitionDialog(
      {super.key, this.onPressed, required this.itemName});

  @override
  ScaleTransitionDialogState createState() => ScaleTransitionDialogState();
}

class ScaleTransitionDialogState extends State<ScaleTransitionDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
          milliseconds: 300), //step one of Animation // Customize the duration
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller!,
      curve: Curves
          .fastLinearToSlowEaseIn, //step two of animation  // Customize the curve
    );

    _controller!.forward(); //step three
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    return ScaleTransition(
      // step four wrap Dialog with Scale Transition and givin scale to the handled scale animation
      scale: _scaleAnimation!,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            gradient: LinearGradient(
              colors: [ColorManager.primaryColor, ColorManager.backGroundColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Amount of ${widget.itemName}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                textInput: TextInputType.number,
                isPassword: false,
                controller: nameController,
                hintText: 'Bon appetit!',
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: ColorManager.primaryColor,
                      backgroundColor: ColorManager.backGroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.onPressed != null) {
                        widget.onPressed!(nameController.text);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.backGroundColor,
                      foregroundColor: ColorManager.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
