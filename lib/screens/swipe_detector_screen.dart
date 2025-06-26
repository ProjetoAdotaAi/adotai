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

class _SwipeScreenState extends State<SwipeScreen> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  double detailsHeight = 0;
  final double maxDetailsHeight = 250;

  late AnimationController _animationController;
  late Animation<double> _detailsHeightAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final interactionProvider = Provider.of<InteractionProvider>(context, listen: false);
      final petProvider = Provider.of<PetProvider>(context, listen: false);

      await interactionProvider.loadAllUserInteractions();
      await petProvider.loadPets(reset: true);

      setState(() {
        currentIndex = 0;
        detailsHeight = 0;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void nextCard() {
    setState(() {
      currentIndex++;
      detailsHeight = 0;
    });
  }

  void createInteraction(PetModel pet, InteractionType type) async {
    final interactionProvider = Provider.of<InteractionProvider>(context, listen: false);
    await interactionProvider.createInteraction(petId: pet.id!, type: type);
    nextCard();
  }

  void animateDetailsHeight(double targetHeight) {
    _animationController.stop();
    _detailsHeightAnimation = Tween<double>(
      begin: detailsHeight,
      end: targetHeight,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {
          detailsHeight = _detailsHeightAnimation.value;
        });
      });
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<PetProvider, InteractionProvider>(
      builder: (context, petProvider, interactionProvider, _) {
        if (petProvider.isLoading || interactionProvider.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (petProvider.errorMessage != null) {
          return Scaffold(
            body: Center(
              child: Text(
                petProvider.errorMessage!,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          );
        }

        final allPets = petProvider.pets;
        final interactedPetIds = interactionProvider.interactedPetIds;
        final filteredPets = allPets.where((p) => !interactedPetIds.contains(p.id)).toList();

        if (filteredPets.isEmpty || currentIndex >= filteredPets.length) {
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

        final pet = filteredPets[currentIndex];
        final nextPet = currentIndex + 1 < filteredPets.length ? filteredPets[currentIndex + 1] : null;
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
                      key: ValueKey(pet.id),
                      onSwipeRight: () => createInteraction(pet, InteractionType.FAVORITED),
                      onSwipeLeft: () => createInteraction(pet, InteractionType.DISCARDED),
                      onSwipeUp: () => animateDetailsHeight(maxDetailsHeight),
                      onSwipeDown: () => animateDetailsHeight(0),
                      onSwipeCancel: () => animateDetailsHeight(0),
                      builder: (offset, rotation) => Center(
                        child: SwipeCard(
                          pet: pet,
                          offset: offset,
                          rotation: rotation,
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
                      onTap: () => createInteraction(pet, InteractionType.DISCARDED),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.red[400],
                        child: const Icon(Icons.close, color: Colors.white, size: 36),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => createInteraction(pet, InteractionType.FAVORITED),
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
