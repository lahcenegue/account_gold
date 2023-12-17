import 'package:account_gold/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class DefaultFormField extends StatelessWidget {
  final String? hint;
  final TextInputType? keyboard;
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final TextDirection? textDirection;
  final String? validator;
  final int? maxLines;
  final int? minLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? isPassword;
  final TextStyle? style;
  final void Function(String)? onChanged;
  final Color? cursorColor;

  const DefaultFormField({
    Key? key,
    this.hint,
    this.keyboard,
    this.controller, this.decoration, this.textDirection, this.validator, this.maxLines, this.minLines, this.prefixIcon, this.suffixIcon, this.isPassword, this.onChanged, this.cursorColor, this.style,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboard,
      controller: controller,
      style: style,
      cursorColor: cursorColor??AppColors.primary,
      onChanged: onChanged,
      obscureText: isPassword??false,
      decoration: decoration ?? InputDecoration(
        fillColor: Colors.grey.withOpacity(0.17),
        filled: true,
          contentPadding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
          hintStyle: TextStyle(color: AppColors.text, fontSize: 16),
    enabledBorder: const OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide.lerp(
            BorderSide(color: AppColors.primary),
            BorderSide(color: AppColors.primary), 20),
        borderRadius: const BorderRadius.all(Radius.circular(5))),
    border: OutlineInputBorder(
    borderSide: BorderSide.lerp(
    BorderSide(color: AppColors.primary),
    BorderSide(color: AppColors.primary), 20),
    borderRadius: const BorderRadius.all(Radius.circular(5))),
        labelText: hint,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      textDirection: textDirection,
      maxLines: maxLines??1,
      minLines: minLines,
      validator: (data){
        if(data!.isEmpty) {
          return validator;
        }
        return null;
      },
    );
  }
}

