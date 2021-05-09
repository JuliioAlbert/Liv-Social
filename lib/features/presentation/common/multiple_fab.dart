import 'package:flutter/material.dart';
import 'package:liv_social/core/theme/pallete_color.dart';

class MultipleFAB extends StatefulWidget {
  const MultipleFAB({
    Key? key,
    required this.icons,
    required AnimationController controller,
    required this.backgroundColor,
    required this.actionButtons,
  })   : _controller = controller,
        super(key: key);

  final List<Widget> icons;
  final AnimationController _controller;
  final Color backgroundColor;
  final List<VoidCallback> actionButtons;

  @override
  _MultipleFABState createState() => _MultipleFABState();
}

class _MultipleFABState extends State<MultipleFAB> {
  late AnimationController animationController;
  late Animation degOneTranslationAnimation,
      degTwoTranslationAnimation,
      degThreeTranslationAnimation;
  late Animation rotationAnimation;
  late Animation rotationAnimationPrincipalButton;
  late Animation scaleAnimationPrincipalButton;

  @override
  void initState() {
    animationController = widget._controller;
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0), weight: 75.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.0, end: 1.0), weight: 25.0),
    ]).animate(widget._controller);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.0, end: 1.0), weight: 45.0),
    ]).animate(widget._controller);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    rotationAnimationPrincipalButton = Tween<double>(begin: 180.0, end: 45.0)
        .animate(CurvedAnimation(
            parent: animationController, curve: Curves.easeOut));
    scaleAnimationPrincipalButton = Tween<double>(begin: 1.0, end: 0.85)
        .animate(CurvedAnimation(
            parent: animationController, curve: Curves.easeOut));
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
  }

  double getRadiansFromIndex(int index, {bool isOdd = false}) {
    final unitRadian = 57.295779513;
    double degree;
    switch (index) {
      case 0:
        degree = isOdd ? 270.0 : 247.0;
        break;
      case 1:
        degree = isOdd ? 220.0 : 293.0;
        break;
      case 2:
        degree = isOdd ? 320.0 : 200;
        break;
      case 3:
        degree = 340.0;
        break;
      default:
        degree = 245.0;
    }
    return degree / unitRadian;
  }

  double getRadiansFromDegree(double degree) {
    final unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  Widget build(BuildContext context) {
    var isOdd = widget.icons.length.isOdd;
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.loose,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        IgnorePointer(
          ignoring: true,
          child: Container(
            // color: Colors.black.withOpacity(0.4),
            color: Colors.transparent,
            width: 130.0,
            height: 140.0,
          ),
        ),
        ...List.generate(
          widget.icons.length,
          (int index) {
            Widget child = SizedBox(
              width: 40.0,
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: widget.backgroundColor,
                onPressed: () {
                  animationController.reverse();
                  widget.actionButtons[index]();
                },
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: widget.icons[index],
                ),
              ),
            );

            return Positioned(
              bottom: 35,
              child: Transform.translate(
                offset: Offset.fromDirection(
                    getRadiansFromIndex(index, isOdd: isOdd),
                    degTwoTranslationAnimation.value * 55),
                child: Transform(
                  transform: Matrix4.rotationZ(
                      getRadiansFromDegree(rotationAnimation.value))
                    ..scale(degTwoTranslationAnimation.value),
                  alignment: Alignment.center,
                  child: child,
                ),
              ),
            );
          },
        ).toList()
          ..add(Positioned(
            bottom: 35,
            child: Transform.scale(
              scale: scaleAnimationPrincipalButton.value,
              child: Transform(
                transform: Matrix4.rotationZ(getRadiansFromDegree(
                    rotationAnimationPrincipalButton.value)),
                alignment: Alignment.center,
                child: FloatingActionButton(
                  heroTag: null,
                  backgroundColor: PalleteColor.actionButtonColor,
                  onPressed: () {
                    if (animationController.isDismissed) {
                      animationController.forward();
                    } else {
                      animationController.reverse();
                    }
                  },
                  child: const Icon(Icons.add, size: 30.0),
                ),
              ),
            ),
          ))
      ],
    );
  }
}
