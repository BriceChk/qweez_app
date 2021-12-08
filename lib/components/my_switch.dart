import 'package:flutter/material.dart';
import 'package:qweez_app/constants/constants.dart';

class MySwitch extends StatefulWidget {
  final ValueChanged<bool>? onChanged;
  final bool value;
  final bool isEnabled;
  final Color activeColor;
  final Color inactiveColor;


  const MySwitch({
    Key? key,
    required this.onChanged,
    this.value = false,
    this.isEnabled = true,
    this.activeColor = colorYellow,
    this.inactiveColor = colorLightGray,
  }) : super(key: key);

  @override
  _MySwitchState createState() => _MySwitchState();
}

class _MySwitchState extends State<MySwitch> with SingleTickerProviderStateMixin {
  late Animation _circleAnimation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _circleAnimation = AlignmentTween(
        begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
        end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Condition to force the update of the switch in the product_add_edit page
    //for the is available when we have the stockManaged to true
    if (_circleAnimation.value == Alignment.centerLeft && widget.value) {
      _circleAnimation = AlignmentTween(
        begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
        end: widget.value ? Alignment.centerLeft : Alignment.centerRight,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      );
      _animationController.reverse();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: widget.isEnabled
              ? widget.onChanged == null
                  ? null
                  : () {
                      if (_animationController.isCompleted) {
                        _animationController.reverse();
                      } else {
                        _animationController.forward();
                      }
                      widget.value == false ? widget.onChanged!(true) : widget.onChanged!(false);
                    }
              : null,
          child: Container(
            width: 47.0,
            height: 30.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: widget.onChanged == null
                  ? widget.inactiveColor
                  : _circleAnimation.value == Alignment.centerLeft
                      ? widget.inactiveColor
                      : widget.activeColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Align(
                alignment: _circleAnimation.value,
                child: Container(
                  width: 22.0,
                  height: 22.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
