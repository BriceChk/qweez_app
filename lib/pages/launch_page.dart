import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qweez_app/constants/constants.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({Key? key}) : super(key: key);

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _colorTween = _animationController.drive(
      ColorTween(
        begin: colorWhite,
        end: colorYellow,
      ),
    );
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
            Column(
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
                  padding: const EdgeInsets.only(top: 50),
                  child: CircularProgressIndicator(
                    valueColor: _colorTween,
                  ),
                ),
              ],
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
