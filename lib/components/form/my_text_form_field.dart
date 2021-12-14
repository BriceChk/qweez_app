import 'package:flutter/material.dart';
import 'package:qweez_app/constants.dart';

class MyTextFormField extends StatelessWidget {
  final String? valueText;
  final String hintText;
  final double margin;
  final Color backgroundColor;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final bool isPassword;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;

  const MyTextFormField({
    Key? key,
    this.valueText,
    required this.hintText,
    this.margin = paddingVertical / 2,
    this.backgroundColor = colorLightGreyForm,
    required this.textInputAction,
    this.textInputType = TextInputType.text,
    this.isPassword = false,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 45),
      margin: EdgeInsets.symmetric(vertical: margin),
      child: TextFormField(
        obscureText: isPassword,
        initialValue: valueText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
          hintText: hintText,
          filled: true,
          fillColor: backgroundColor,
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: fontSizeText,
            color: colorLightGray,
          ),
          errorStyle: const TextStyle(
            color: colorRed,
            fontWeight: FontWeight.w700,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: colorYellow,
              width: 2.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: colorRed,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(
              color: colorYellow,
              width: 2.0,
            ),
          ),
        ),
        textInputAction: textInputAction,
        keyboardType: textInputType,
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}
