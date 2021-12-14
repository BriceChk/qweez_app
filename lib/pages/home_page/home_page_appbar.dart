import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qweez_app/components/form/my_text_form_field.dart';
import 'package:qweez_app/constants.dart';
import 'package:qweez_app/main.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSize {
  final Function() onQrCodeTap;
  final BuildContext context;

  const HomePageAppBar({
    Key? key,
    required this.onQrCodeTap,
    required this.context,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size(double.infinity, 250);

  @override
  Widget get child {
    return Container(
      color: colorBlue.withOpacity(0.9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
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
              if (MyApp.user != null)
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
                        const PopupMenuItem(
                          value: 3,
                          child: Text('License informations'),
                        ),
                      ];
                    },
                    onSelected: (result) {
                      switch (result) {
                        // Case when we hit "delete account"
                        case 1:
                          _showDeleteAccountConfirmation();
                          break;
                        // Case when we hit "Log out"
                        case 2:
                          FirebaseAuth.instance.signOut();
                          break;
                        // Case when we hit "license infos"
                        case 3:
                          showLicensePage(context: context, applicationName: 'Qweez');
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
                        MyApp.user!.email![0].toUpperCase() + MyApp.user!.email![1],
                        style: const TextStyle(
                          fontSize: fontSizeSubtitle,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Scanning and enter code + title container
          Container(
            margin: const EdgeInsets.only(top: paddingVertical + 5),
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
                    Expanded(
                      child: MyTextFormField(
                        hintText: 'Enter a code',
                        margin: paddingVertical,
                        backgroundColor: colorWhite,
                        textInputAction: TextInputAction.done,
                        onChanged: (value) async {
                          if (value.length == 5) {
                            //TODO Aller sur la page de join quiz
                          }
                        },
                      ),
                    ),
                    if (!kIsWeb)
                      Container(
                        margin: const EdgeInsets.only(left: paddingVertical / 2),
                        child: Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          color: colorBlack,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: onQrCodeTap,
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
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }

  Future<void> _showDeleteAccountConfirmation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius / 1.5),
          ),
          title: const Text('Do you want to delete your account?'),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(
                  colorBlue.withOpacity(0.15),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: fontSizeText,
                  color: colorBlue,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(
                  colorRed.withOpacity(0.15),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontSize: fontSizeText,
                  color: colorRed,
                ),
              ),
              onPressed: () {
                FirebaseAuth.instance.currentUser!.delete();
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
