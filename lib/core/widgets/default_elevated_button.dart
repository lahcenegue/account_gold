import 'package:account_gold/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class DefaultElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? color;
  final ButtonStyle? style;
  const DefaultElevatedButton({Key? key, this.onPressed, required this.child, this.color, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style??ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color??AppColors.primary),
        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50))
      ),
      child: child,
      );
  }
}
