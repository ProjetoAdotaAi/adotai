import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pet_model.dart';
import '../models/interaction_type.dart';
import '../providers/pet_provider.dart';
import '../providers/interaction_provider.dart';
import '../widgets/swipe/swipe_card.dart';
import '../widgets/swipe/swipe_controller.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  int currentIndex = 0;
  double detailsHeight = 0;
  final double maxDetailsHeight = 250;

  void nextCard() {
    setState(() {
      currentIndex++;
      detailsHeight = 0;
    });
  }

  void createInteraction(PetModel pet, InteractionType type) {
    final provider = Provider.of<InteractionProvider>(context, listen: false);
    provider.createInteraction(petId: pet.id!, type: type);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PetProvider>(context, listen: false).loadPets();
    });
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
            body: Center(
              child: Text(
                provider.errorMessage!,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          );
        }

        if (currentIndex >= pets.length) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.pets, size: 72, color: Theme.of(context).primaryColor),
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
                          opacity: 0.5,
                          child: SwipeCard(
                            pet: nextPet,
                            offset: Offset.zero,
                            rotation: 0,
                            detailsHeight: 0,
                          ),
                        ),
                      ),
                    SwipeController(
                      onSwipeRight: () {
                        createInteraction(pet, InteractionType.FAVORITED);
                        nextCard();
                      },
                      onSwipeLeft: () {
                        createInteraction(pet, InteractionType.DISCARDED);
                        nextCard();
                      },
                      onSwipeUp: () {
                        setState(() => detailsHeight = maxDetailsHeight);
                      },
                      onSwipeCancel: () {
                        setState(() => detailsHeight = 0);
                      },
                      builder: (offset, rotation) {
                        return Center(
                          child: SwipeCard(
                            pet: pet,
                            offset: offset,
                            rotation: rotation,
                            detailsHeight: detailsHeight,
                          ),
                        );
                      },
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
                      onTap: () {
                        createInteraction(pet, InteractionType.DISCARDED);
                        nextCard();
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.red[400],
                        child: const Icon(Icons.close, color: Colors.white, size: 36),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        createInteraction(pet, InteractionType.FAVORITED);
                        nextCard();
                      },
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
