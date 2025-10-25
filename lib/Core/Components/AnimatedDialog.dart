import 'package:PureFit/Core/Components/custom_text_field.dart';
import 'package:PureFit/Core/Shared/app_string.dart';
import 'package:flutter/material.dart';

class ScaleTransitionDialog extends StatefulWidget {
  const ScaleTransitionDialog(
      {required this.itemName, super.key, this.onPressed});
  final void Function(String)? onPressed;
  final String itemName;

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
    final theme = Theme.of(context);
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
            color: theme.cardColor,
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${AppString.amountOf(context)} ${widget.itemName}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                textInput: TextInputType.number,
                isPassword: false,
                controller: nameController,
                hintText: AppString.bonAppetit(context),
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
                      foregroundColor: theme.colorScheme.onSurface,
                      backgroundColor: theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: theme.colorScheme.outline),
                      ),
                    ),
                    child: Text(
                      AppString.cancel(context),
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.onPressed != null) {
                        widget.onPressed!(nameController.text);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      AppString.add(context),
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
