import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:qweez_app/constants.dart';

class ErrorPage extends StatelessWidget {
  final String message;

  const ErrorPage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: colorBlue.withOpacity(0.9),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Qweez',
                    style: TextStyle(
                      fontSize: fontSizeAppName,
                      color: colorWhite,
                      fontWeight: FontWeight.w900,
                      fontFamily: fontHKGrotesk,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: paddingVertical * 3, bottom: paddingVertical * 2),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: fontSizeSubtitle,
                        color: colorWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.beamToNamed('/');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: paddingVertical / 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(right: paddingHorizontal / 3),
                            child: Text('Home page'),
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 80,
              left: -50,
              child: Container(
                height: 200,
                width: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorBlue,
                ),
              ),
            ),
            Positioned(
              right: -40,
              bottom: 50,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 160,
                  width: 160,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
