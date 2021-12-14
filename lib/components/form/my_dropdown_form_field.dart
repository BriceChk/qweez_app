import 'package:flutter/material.dart';
import 'package:qweez_app/constants.dart';

class MyDropDownFormField extends StatelessWidget {
  final String hintText;
  final String titleText;
  final String value;
  final FormFieldValidator<String>? validator;
  final void Function(String?)? onChanged;
  final List<String> itemsList;

  const MyDropDownFormField({
    Key? key,
    required this.titleText,
    required this.hintText,
    required this.value,
    required this.itemsList,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: const TextStyle(
            color: colorDarkGray,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: paddingVertical / 2,
            bottom: paddingVertical,
          ),
          child: DropdownButtonFormField<String>(
            style: const TextStyle(
              color: colorDarkGray,
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: colorLightGray,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
              filled: true,
              fillColor: colorLightGreyForm,
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
            value: value,
            isExpanded: true,
            items: itemsList.map((element) {
              return DropdownMenuItem<String>(
                value: element,
                child: Text(
                  element,
                ),
              );
            }).toList(),
            onChanged: onChanged,
            validator: validator,
          ),
        ),
      ],
    );
  }
}
