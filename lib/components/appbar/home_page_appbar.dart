import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qweez_app/components/form/my_text_form_field.dart';
import 'package:qweez_app/constants/constants.dart';
import 'package:qweez_app/main.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSize {
  final Function() onTap;

  const HomePageAppBar({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Size get preferredSize => Size(double.infinity, kIsWeb ? 250 : 200 + MyApp.sizeNotificationBar);

  @override
  Widget get child => Container(
        color: colorBlue.withOpacity(0.9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: paddingVertical),
              child: Text(
                'Qweez',
                style: TextStyle(
                  fontSize: fontSizeAppName,
                  color: colorWhite,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            // Scanning and enter code + title container
            Container(
              margin: const EdgeInsets.only(top: paddingVertical),
              padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
              decoration: const BoxDecoration(
                color: colorBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  topRight: Radius.circular(borderRadius),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: fontSizeTitle,
                      color: colorWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: MyTextFormField(
                          hintText: 'Enter a code',
                          valueText: null,
                          margin: paddingVertical,
                          backgroundColor: colorWhite,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: paddingVertical / 2),
                        child: Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          color: colorBlack,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: onTap,
                            highlightColor: Colors.transparent,
                            splashColor: colorWhite.withOpacity(0.25),
                            child: const Padding(
                              padding: EdgeInsets.all(paddingHorizontal / 3),
                              child: Icon(
                                Icons.qr_code_scanner_rounded,
                                color: colorWhite,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
