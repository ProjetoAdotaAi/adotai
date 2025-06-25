import 'package:flutter/material.dart';

typedef SwipeBuilder = Widget Function(Offset offset, double rotation);

class SwipeController extends StatefulWidget {
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeUp;
  final VoidCallback onSwipeDown;
  final VoidCallback onSwipeCancel;
  final SwipeBuilder builder;

  const SwipeController({
    required this.onSwipeRight,
    required this.onSwipeLeft,
    required this.onSwipeUp,
    required this.onSwipeDown,
    required this.onSwipeCancel,
    required this.builder,
    super.key,
  });

  @override
  State<SwipeController> createState() => _SwipeControllerState();
}

class _SwipeControllerState extends State<SwipeController>
    with SingleTickerProviderStateMixin {
  Offset cardOffset = Offset.zero;
  double cardRotation = 0;

  late AnimationController animationController;
  late Animation<Offset> animationOffset;
  late Animation<double> animationRotation;

  bool isDragging = false;
  bool isVerticalDrag = false;
  double verticalDragDirection = 0; // >0 down, <0 up

  static const double swipeThreshold = 150;
  static const double maxRotation = 0.35;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    animationController.addListener(() {
      setState(() {
        cardOffset = animationOffset.value;
        cardRotation = animationRotation.value;
      });
    });

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (cardOffset.dx > swipeThreshold) {
          widget.onSwipeRight();
        } else if (cardOffset.dx < -swipeThreshold) {
          widget.onSwipeLeft();
        } else if (isVerticalDrag) {
          if (verticalDragDirection < 0) {
            widget.onSwipeUp();
          } else {
            widget.onSwipeDown();
          }
        } else {
          widget.onSwipeCancel();
        }

        cardOffset = Offset.zero;
        cardRotation = 0;
        isVerticalDrag = false;
        verticalDragDirection = 0;
        animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void animateBack() {
    animationOffset = Tween<Offset>(
      begin: cardOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ));

    animationRotation = Tween<double>(
      begin: cardRotation,
      end: 0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ));

    animationController.forward(from: 0);
  }

  void animateCardOut(Offset targetOffset, double targetRotation) {
    animationOffset = Tween<Offset>(
      begin: cardOffset,
      end: targetOffset,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    ));

    animationRotation = Tween<double>(
      begin: cardRotation,
      end: targetRotation,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    ));

    animationController.forward(from: 0);
  }

  void handleSwipeEnd() {
    final screenWidth = MediaQuery.of(context).size.width;

    if (!isVerticalDrag) {
      if (cardOffset.dx > swipeThreshold) {
        animateCardOut(Offset(screenWidth * 1.5, 0), maxRotation);
      } else if (cardOffset.dx < -swipeThreshold) {
        animateCardOut(Offset(-screenWidth * 1.5, 0), -maxRotation);
      } else {
        animateBack();
      }
    } else {
      if (verticalDragDirection < 0) {
        widget.onSwipeUp();
      } else {
        widget.onSwipeDown();
      }
      animateBack();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (_) {
        isDragging = true;
        isVerticalDrag = false;
        verticalDragDirection = 0;
        animationController.stop();
      },
      onPanUpdate: (details) {
        if (!isDragging) return;

        final delta = details.delta;

        if (!isVerticalDrag &&
            delta.dy.abs() > delta.dx.abs() &&
            delta.dy.abs() > 5) {
          isVerticalDrag = true;
        }

        if (isVerticalDrag) {
          verticalDragDirection = delta.dy;
          return;
        }

        setState(() {
          final newDx = cardOffset.dx + delta.dx;
          cardOffset = Offset(newDx, 0);
          cardRotation = (maxRotation * newDx / MediaQuery.of(context).size.width)
              .clamp(-maxRotation, maxRotation);
        });
      },
      onPanEnd: (_) {
        isDragging = false;
        handleSwipeEnd();
      },
      child: widget.builder(cardOffset, cardRotation),
    );
  }
}
