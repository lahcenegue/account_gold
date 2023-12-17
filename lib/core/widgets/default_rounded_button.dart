import 'package:account_gold/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class DefaultRoundedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? color;
  final ButtonStyle? style;
  const DefaultRoundedButton({Key? key, this.onPressed, required this.child, this.color, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style??ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
          )),
        backgroundColor: MaterialStateProperty.all<Color>(color??AppColors.primary),
        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 50))
      ),

      child: child,
      );
  }
}
