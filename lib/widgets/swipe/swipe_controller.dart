import 'package:flutter/material.dart';

typedef SwipeBuilder = Widget Function(Offset offset, double rotation);

class SwipeController extends StatefulWidget {
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeUp;
  final VoidCallback onSwipeCancel;
  final SwipeBuilder builder;

  const SwipeController({
    required this.onSwipeRight,
    required this.onSwipeLeft,
    required this.onSwipeUp,
    required this.onSwipeCancel,
    required this.builder,
    super.key,
  });

  @override
  State<SwipeController> createState() => _SwipeControllerState();
}

class _SwipeControllerState extends State<SwipeController> with SingleTickerProviderStateMixin {
  Offset cardOffset = Offset.zero;
  double cardRotation = 0;

  late AnimationController animationController;
  late Animation<Offset> animationOffset;
  late Animation<double> animationRotation;

  bool isDragging = false;
  bool isVerticalDrag = false;

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
        if (cardOffset.dx > 150) {
          widget.onSwipeRight();
        } else if (cardOffset.dx < -150) {
          widget.onSwipeLeft();
        } else if (cardOffset.dy < -150) {
          widget.onSwipeUp();
        } else {
          widget.onSwipeCancel();
        }

        cardOffset = Offset.zero;
        cardRotation = 0;
        isVerticalDrag = false;
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
    animationOffset = Tween<Offset>(begin: cardOffset, end: Offset.zero).animate(animationController);
    animationRotation = Tween<double>(begin: cardRotation, end: 0).animate(animationController);
    animationController.forward(from: 0);
  }

  void animateCardOut(Offset targetOffset) {
    animationOffset = Tween<Offset>(begin: cardOffset, end: targetOffset).animate(animationController);
    animationRotation = Tween<double>(begin: cardRotation, end: 0).animate(animationController);
    animationController.forward(from: 0);
  }

  void handleSwipeEnd() {
    if (!isVerticalDrag) {
      if (cardOffset.dx > 150) {
        animateCardOut(const Offset(500, 0));
      } else if (cardOffset.dx < -150) {
        animateCardOut(const Offset(-500, 0));
      } else {
        animateBack();
      }
    } else {
      if (cardOffset.dy < -150) {
        animateCardOut(const Offset(0, -500));
      } else {
        animateBack();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (_) {
        isDragging = true;
        isVerticalDrag = false;
      },
      onPanUpdate: (details) {
        if (!isDragging) return;

        final dx = cardOffset.dx + details.localPosition.dx;

        if (!isVerticalDrag) {
          // Detecta se o movimento vertical é relevante pra swipe up
          if (details.localPosition.dy < -3) {
            isVerticalDrag = true;
          }
        }

        setState(() {
          if (isVerticalDrag) {
            // Arrasto para cima
            final dy = (cardOffset.dy + details.localPosition.dy).clamp(-500, 0);
            cardOffset = Offset(0, dy.toDouble());
            cardRotation = 0;
          } else {
            // Arrasto horizontal com rotação proporcional a dx
            cardOffset = Offset(dx, 0);
            cardRotation = 0;
          }
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
