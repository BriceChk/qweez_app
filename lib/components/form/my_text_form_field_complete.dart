import 'package:flutter/material.dart';
import 'package:qweez_app/components/form/my_text_form_field.dart';
import 'package:qweez_app/constants/constants.dart';

class MyTextFormFieldComplete extends StatelessWidget {
  final String titleText;
  final bool required;
  final String? valueText;
  final String hintText;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final FormFieldValidator<String> validator;
  final Function(String)? onChanged;

  const MyTextFormFieldComplete({
    Key? key,
    required this.titleText,
    required this.valueText,
    required this.hintText,
    this.required = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    required this.validator,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: paddingVertical),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titleText,
            style: const TextStyle(
              color: colorDarkGray,
            ),
          ),
          MyTextFormField(
            valueText: valueText,
            hintText: hintText,
            textInputAction: textInputAction,
            textInputType: textInputType,
            validator: validator,
            onChanged: onChanged,
          ),
          if (required)
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Required',
                style: TextStyle(
                  color: colorDarkGray,
                  fontSize: fontSizeText / 1.35,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
