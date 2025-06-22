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

class _SwipeControllerState extends State<SwipeController>
    with SingleTickerProviderStateMixin {
  Offset cardOffset = Offset.zero;
  double cardRotation = 0;

  late AnimationController animationController;
  late Animation<Offset> animationOffset;
  late Animation<double> animationRotation;

  bool isDragging = false;
  bool isVerticalDrag = false;

  static const double swipeThreshold = 150;
  static const double maxRotation = 0.35; // ~20 degrees

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
        } else if (cardOffset.dy < -swipeThreshold) {
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
    animationOffset =
        Tween<Offset>(begin: cardOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );
    animationRotation =
        Tween<double>(begin: cardRotation, end: 0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );
    animationController.forward(from: 0);
  }

  void animateCardOut(Offset targetOffset) {
    animationOffset =
        Tween<Offset>(begin: cardOffset, end: targetOffset).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );
    animationRotation =
        Tween<double>(begin: cardRotation, end: 0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );
    animationController.forward(from: 0);
  }

  void handleSwipeEnd() {
    if (!isVerticalDrag) {
      if (cardOffset.dx > swipeThreshold) {
        animateCardOut(const Offset(500, 0));
      } else if (cardOffset.dx < -swipeThreshold) {
        animateCardOut(const Offset(-500, 0));
      } else {
        animateBack();
      }
    } else {
      if (cardOffset.dy < -swipeThreshold) {
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

        final delta = details.delta;

        if (!isVerticalDrag) {
          // Determina se o gesto é vertical ou horizontal depois de um threshold mínimo
          if (delta.dy.abs() > delta.dx.abs() && delta.dy.abs() > 5) {
            isVerticalDrag = true;
          }
        }

        setState(() {
          if (isVerticalDrag) {
            // Só movimenta verticalmente para cima, com limite
            final newDy = (cardOffset.dy + delta.dy).clamp(-500, 0);
            cardOffset = Offset(0, newDy.toDouble());
            cardRotation = 0;
          } else {
            // Movimento horizontal com rotação proporcional
            final newDx = cardOffset.dx + delta.dx;
            cardOffset = Offset(newDx, 0);

            // Rotação proporcional à distância arrastada, limitando o ângulo
            cardRotation = (maxRotation * newDx / MediaQuery.of(context).size.width)
                .clamp(-maxRotation, maxRotation);
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
