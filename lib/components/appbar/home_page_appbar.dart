import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qweez_app/components/form/my_text_form_field.dart';
import 'package:qweez_app/constants/constants.dart';
import 'package:qweez_app/main.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSize {
  final Function() onTap;
  final Function() setState;

  const HomePageAppBar({
    Key? key,
    required this.onTap,
    required this.setState,
  }) : super(key: key);

  @override
  Size get preferredSize => Size(double.infinity, kIsWeb ? 250 : 200 + MyApp.sizeNotificationBar);

  @override
  Widget get child => Container(
        color: colorBlue.withOpacity(0.9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: paddingVertical),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Text(
                    'Qweez',
                    style: TextStyle(
                      fontSize: fontSizeAppName,
                      color: colorWhite,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (MyApp.userCredential != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: PopupMenuButton<int>(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(borderRadius / 2),
                          ),
                        ),
                        itemBuilder: (BuildContext context) {
                          return <PopupMenuEntry<int>>[
                            const PopupMenuItem(
                              value: 1,
                              child: Text('Delete account'),
                            ),
                            const PopupMenuItem(
                              value: 2,
                              child: Text('Log out'),
                            ),
                          ];
                        },
                        onSelected: (result) {
                          switch (result) {
                            // Case when we hit "delete account"
                            case 1:
                              //TODO
                              print('delete');
                              break;
                            // Case when we hit "Log out"
                            case 2:
                              //TODO
                              setState;
                              break;
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: paddingHorizontal),
                          padding: const EdgeInsets.symmetric(
                            vertical: paddingVertical / 3,
                            horizontal: paddingHorizontal / 3,
                          ),
                          decoration: const BoxDecoration(
                            color: colorWhite,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            MyApp.userCredential!.user!.email![0].toUpperCase() + MyApp.userCredential!.user!.email![1],
                            style: const TextStyle(
                              fontSize: fontSizeSubtitle,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
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
