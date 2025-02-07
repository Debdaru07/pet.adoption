import 'dart:ui';

import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import 'package:confetti/confetti.dart';


class PetDetailPage extends StatefulWidget {
  final PetModel pet;

  const PetDetailPage({super.key, required this.pet});

  @override
  State<PetDetailPage> createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey[200],
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return Stack(
                                children: [
                                  BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                    child: Container(
                                      color: Colors.black.withOpacity(0.2),
                                    ),
                                  ),
                                  Center(
                                    child: Dialog(
                                      backgroundColor: Colors.transparent,
                                      insetPadding: EdgeInsets.all(10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: InteractiveViewer(
                                          minScale: 0.6,
                                          maxScale: 4.0,
                                          child: Image.network(
                                            widget.pet.imageUrl,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                widget.pet.imageUrl,
                                height: 325,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 30,
                              right: 8,
                              child: (widget.pet.adoptedDate ?? '').trim().isNotEmpty
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green, // Adopted label color
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.check_circle, color: Colors.white, size: 20), // Check icon
                                          const SizedBox(width: 4),
                                          const Text(
                                            "Adopted",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(), 
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  
        
                  // Pet Details Card
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Container(
                      padding: const EdgeInsets.only(top: 24, bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            widget.pet.name,
                                            style: const TextStyle(
                                                fontSize: 22, fontWeight: FontWeight.bold),
                                          ),
                                          Text(' (${widget.pet.breed})',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey[500])),
                                        ],
                                      ),
                                      
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          widget.pet.imageUrl,
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _buildDetailChip("Female", Colors.green),
                                      _buildDetailChip("${widget.pet.age} yrs.", Colors.blue),
                                      _buildDetailChip("${widget.pet.age * 3} kg", Colors.purple),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, color: Colors.red),
                                      Text(widget.pet.collectPetFrom),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Owner Details
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(widget.pet.imageUrl),
                                        radius: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        widget.pet.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: const Icon(Icons.phone, color: Colors.green),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.chat, color: Colors.blue),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "I am ${widget.pet.name}, Jenny's momma. I am relocating and don’t have enough space to keep ${widget.pet.name} with me. Your life will be joyful once you take ${widget.pet.name} into it.",
                                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Adopt Button
                  Visibility(
                    visible: (widget.pet.adoptedDate ?? '').trim().isEmpty,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _showAdoptionConfirmationDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            "Adopt ${widget.pet.name}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: [Colors.purple, Colors.yellow, Colors.blue],
            gravity: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailChip(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showAdoptionConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade200, // Light grey background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          title: Row(
            children: [
              Icon(Icons.pets, color: Colors.purple.shade700), // Pet icon
              const SizedBox(width: 8),
              Text(
                "Confirm Adoption",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.purple.shade700, // Purple theme color
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to adopt ${widget.pet.name} ?",
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _confettiController.play(); 
                showAdoptionToast(context, widget.pet.name);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 6),
                  const Text(
                    "Adopt",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void showAdoptionToast(BuildContext context, String petName) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).viewInsets.top + 70, // Position from top
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.pets, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "You have adopted $petName 🎉",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto remove after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      overlayEntry.remove();
    });
  }

}
