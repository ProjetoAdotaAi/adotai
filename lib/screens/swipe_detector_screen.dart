import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pet_model.dart';
import '../providers/pet_provider.dart';
import '../widgets/swipe/swipe_card.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  int currentIndex = 0;
  Offset cardOffset = Offset.zero;
  double cardRotation = 0;
  double detailsHeight = 0;
  final double maxDetailsHeight = 250;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PetProvider>(context, listen: false).loadPets();
    });
  }

  void nextCard() {
    setState(() {
      currentIndex++;
      cardOffset = Offset.zero;
      cardRotation = 0;
      detailsHeight = 0;
    });
  }

  void handleSwipeEnd(List<PetModel> pets) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (cardOffset.dx.abs() > screenWidth * 0.25) {
      nextCard();
    } else {
      setState(() {
        cardOffset = Offset.zero;
        cardRotation = 0;
      });
    }
  }

  void swipeLeft(List<PetModel> pets) {
    if (currentIndex >= pets.length) return;
    setState(() {
      cardOffset = const Offset(-500, 0);
      cardRotation = -0.3;
    });
    Future.delayed(const Duration(milliseconds: 300), nextCard);
  }

  void swipeRight(List<PetModel> pets) {
    if (currentIndex >= pets.length) return;
    setState(() {
      cardOffset = const Offset(500, 0);
      cardRotation = 0.3;
    });
    Future.delayed(const Duration(milliseconds: 300), nextCard);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PetProvider>(
      builder: (context, provider, _) {
        final pets = provider.pets;

        if (provider.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (provider.errorMessage != null) {
          return Scaffold(
            body: Center(child: Text(provider.errorMessage!, style: const TextStyle(fontSize: 18))),
          );
        }

        if (currentIndex >= pets.length) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.pets,
                    size: 72,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sem mais pets',
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Volte mais tarde para ver novos amigos!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final pet = pets[currentIndex];
        final nextPet = currentIndex + 1 < pets.length ? pets[currentIndex + 1] : null;
        final bottomPadding = MediaQuery.of(context).padding.bottom;

        return Scaffold(
          backgroundColor: Colors.grey[200],
          body: Stack(
            children: [
              SafeArea(
                child: Stack(
                  children: [
                    if (nextPet != null)
                      Center(
                        child: Opacity(
                          opacity: (cardOffset.dx.abs() /
                                  (MediaQuery.of(context).size.width * 0.25))
                              .clamp(0.0, 1.0),
                          child: SwipeCard(
                            pet: nextPet,
                            offset: Offset.zero,
                            rotation: 0,
                            detailsHeight: 0,
                          ),
                        ),
                      ),
                    GestureDetector(
                      onPanStart: (_) {
                        isDragging = true;
                      },
                      onPanUpdate: (details) {
                        if (!isDragging) return;

                        if (details.delta.dx.abs() > details.delta.dy.abs()) {
                          setState(() {
                            cardOffset += Offset(details.delta.dx, 0);
                            cardRotation = cardOffset.dx / 300;
                            detailsHeight = 0;
                          });
                        } else {
                          setState(() {
                            detailsHeight -= details.delta.dy;
                            if (detailsHeight < 0) detailsHeight = 0;
                            if (detailsHeight > maxDetailsHeight)
                              detailsHeight = maxDetailsHeight;
                          });
                        }
                      },
                      onPanEnd: (_) {
                        isDragging = false;

                        if (detailsHeight > maxDetailsHeight / 2) {
                          setState(() {
                            detailsHeight = maxDetailsHeight;
                            cardOffset = Offset.zero;
                            cardRotation = 0;
                          });
                        } else if (detailsHeight > 0) {
                          setState(() {
                            detailsHeight = 0;
                          });
                          handleSwipeEnd(pets);
                        } else {
                          handleSwipeEnd(pets);
                        }
                      },
                      child: Center(
                        child: SwipeCard(
                          pet: pet,
                          offset: cardOffset,
                          rotation: cardRotation,
                          detailsHeight: detailsHeight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: (bottomPadding > 0 ? bottomPadding : 16) + detailsHeight,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => swipeLeft(pets),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.red[400],
                        child: const Icon(Icons.close, color: Colors.white, size: 36),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => swipeRight(pets),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.green[400],
                        child: const Icon(Icons.favorite, color: Colors.white, size: 36),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
