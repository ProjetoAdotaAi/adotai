import 'package:flutter/material.dart';
import '../../models/pet_model.dart';
import '../report/reportDialog.dart';

class SwipeCard extends StatefulWidget {
  final PetModel pet;
  final Offset offset;
  final double rotation;
  final double detailsHeight;

  const SwipeCard({
    required this.pet,
    required this.offset,
    required this.rotation,
    this.detailsHeight = 0,
    super.key,
  });

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  int currentPhotoIndex = 0;

  void _handleTapDown(TapDownDetails details, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final dx = details.localPosition.dx;

    if (dx < width / 2) {
      if (currentPhotoIndex > 0) {
        setState(() => currentPhotoIndex--);
      }
    } else {
      if (currentPhotoIndex < widget.pet.photos.length - 1) {
        setState(() => currentPhotoIndex++);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;
    final maxDetailsHeight = 250.0;
    final photos = pet.photos;
    final hasPhotos = photos.isNotEmpty;
    final imageUrl = hasPhotos ? photos[currentPhotoIndex].url : '';

    return Transform.translate(
      offset: widget.offset,
      child: Transform.rotate(
        angle: widget.rotation,
        child: Card(
          margin: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          elevation: 8,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.85,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (hasPhotos)
                  GestureDetector(
                    onTapDown: (details) => _handleTapDown(details, context),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                Positioned(
                  bottom: widget.detailsHeight + 60,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '${pet.name}, ${pet.age.displayName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 8, color: Colors.black)],
                      ),
                    ),
                  ),
                ),
                if (hasPhotos && photos.length > 1)
                  Positioned(
                    top: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        photos.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: index == currentPhotoIndex
                                ? Colors.white
                                : Colors.white54,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: widget.detailsHeight.clamp(0, maxDetailsHeight),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Opacity(
                      opacity: widget.detailsHeight / maxDetailsHeight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pet.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${pet.age.displayName} • ${pet.species.displayName} • ${pet.size.displayName}',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                pet.description,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () {
                                showReportDialog(context, pet.id!);
                              },
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Color(0xFFF4A261), // Borda laranja
                                  width: 2,
                                ),
                                padding: const EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(
                                Icons.warning,
                                color: Color(0xFFF4A261), // Laranja do AdotaAI
                                size: 24,
                              ),
                              tooltip: 'Denunciar publicação',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
