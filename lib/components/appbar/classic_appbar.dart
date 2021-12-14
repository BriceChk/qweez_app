import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:qweez_app/constants.dart';

class ClassicAppbar extends StatelessWidget implements PreferredSize {
  final String title;

  const ClassicAppbar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size(double.infinity, 100);

  @override
  Widget get child => Container(
        color: colorBlue.withOpacity(0.9),
        padding: const EdgeInsets.only(top: paddingVertical * 2),
        child: Container(
          height: 85,
          width: double.maxFinite,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: paddingVertical * 2),
          padding: const EdgeInsets.symmetric(
            horizontal: paddingHorizontal,
          ),
          decoration: const BoxDecoration(
            color: colorBlue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
            ),
          ),
          child: AutoSizeText(
            title,
            maxLines: 1,
            style: const TextStyle(
              fontSize: fontSizeTitle,
              color: colorWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
