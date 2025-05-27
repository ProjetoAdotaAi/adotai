import 'package:flutter/material.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> with SingleTickerProviderStateMixin {
  List<Map<String, String>> dogs = [
    {
      'name': 'Bob',
      'age': '3 meses',
      'image': 'assets/images/dog1.jpg',
      'details': 'Bob é um filhote brincalhão que adora corridas e carinho.'
    },
    {
      'name': 'Tabaco',
      'age': '1 ano',
      'image': 'assets/images/dog2.jpg',
      'details': 'Tabaco é calmo e adora longas caminhadas.'
    },
    {
      'name': 'Tobias',
      'age': '2 anos',
      'image': 'assets/images/dog3.jpg',
      'details': 'Tobias é muito amigável e ótimo com crianças.'
    },
    {
      'name': 'Fiapo',
      'age': '4 meses',
      'image': 'assets/images/dog4.jpg',
      'details': 'Fiapo adora brincar e está pronto para um novo lar.'
    },
  ];

  int currentIndex = 0;
  Offset cardOffset = Offset.zero;
  double cardRotation = 0;
  late AnimationController animationController;
  late Animation<Offset> animationOffset;
  late Animation<double> animationRotation;

  bool isDragging = false;

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
        if (cardOffset.dx.abs() > 150) {
          _nextCard();
        } else if (cardOffset == Offset.zero) {
          isDragging = false;
          animationController.reset();
        }
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _nextCard() {
  setState(() {
    currentIndex++;
    cardOffset = Offset.zero;
    cardRotation = 0;
    isDragging = false;
  });
  animationController.reset();
}

  void _handleSwipeAction() {
    if (cardOffset.dx > 150) {
      _animateCardOut(Offset(500, 0), rotate: false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Você curtiu ${dogs[currentIndex]['name']}! 🐶')),
      );
    } else if (cardOffset.dx < -150) {
      _animateCardOut(Offset(-500, 0), rotate: false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Você rejeitou ${dogs[currentIndex]['name']}.')),
      );
    } else if (cardOffset.dy < -150) {
      _showDetails(dogs[currentIndex]);
      _animateBack();
    } else if (cardOffset.dy > 150) {
      _showDetails(dogs[currentIndex]);
      _animateBack();
    } else {
      _animateBack();
    }
  }

  void _animateBack() {
    animationOffset = Tween<Offset>(begin: cardOffset, end: Offset.zero).animate(animationController);
    animationRotation = Tween<double>(begin: cardRotation, end: 0).animate(animationController);
    animationController.forward(from: 0);
  }

  void _animateCardOut(Offset targetOffset, {required bool rotate}) {
  animationOffset = Tween<Offset>(begin: cardOffset, end: targetOffset).animate(animationController);
  animationRotation = Tween<double>(
    begin: cardRotation,
    end: rotate ? (cardOffset.dx > 0 ? 0.5 : -0.5) : 0,
  ).animate(animationController);

  animationController.forward(from: 0).whenComplete(() {
    setState(() {
      cardOffset = Offset.zero;
      cardRotation = 0;
    });
  });
}

  void _showDetails(Map<String, String> dog) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dog['name']!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(dog['age']!, style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 16),
            Text(dog['details']!, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentIndex >= dogs.length) {
      return Scaffold(
        body: const Center(child: Text('Sem mais cachorros :(')),
      );
    }

    final dog = dogs[currentIndex];

    return Scaffold(
      body: Center(
        child: GestureDetector(
          onPanStart: (_) {
            isDragging = true;
          },
          onPanUpdate: (details) {
            if (!isDragging) return;
            setState(() {
              cardOffset += details.delta;

              // rotaciona só no drag horizontal
              if (cardOffset.dx.abs() > cardOffset.dy.abs()) {
                cardRotation = cardOffset.dx / 300;
              } else {
                cardRotation = 0;
              }
            });
          },
          onPanEnd: (_) {
            isDragging = false;
            _handleSwipeAction();
          },
          child: Transform.translate(
            offset: cardOffset,
            child: Transform.rotate(
              angle: cardRotation,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 8,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(dog['image']!, fit: BoxFit.cover),
                        Container(
                          alignment: Alignment.bottomLeft,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black54],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Text(
                            '${dog['name']}, ${dog['age']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              shadows: [Shadow(blurRadius: 8, color: Colors.black)],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
