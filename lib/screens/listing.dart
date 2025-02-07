import 'package:flutter/material.dart';

import '../models/pet_model.dart';
import '../services/db_services.dart';
import 'pet_details.dart';

class PetListScreen extends StatefulWidget {
  const PetListScreen({super.key});

  @override
  _PetListScreenState createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  List<PetModel> pets = [];

  @override
  void initState() {
    super.initState();
    _fetchPets();
  }

  Future<void> _fetchPets() async {
    final data = await DatabaseHelper.instance.getPetsAsListOfPetModel();
    setState(() {
      pets = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Petadopt')),
      body: pets.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two items per row
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75, // Adjust height
      ),
      itemCount: pets.length,
      itemBuilder: (context, index) {
        final pet = pets[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PetDetailPage(pet: pet),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        pet.imageUrl,
                        height: 177.5,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.pets, size: 50, color: Colors.grey),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: (pet.adoptedDate ?? '').trim().isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green, // Adopted label color
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.check_circle, color: Colors.white, size: 14), // Check icon
                                  const SizedBox(width: 4),
                                  const Text(
                                    "Adopted",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(), // If not adopted, show nothing
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pet.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          _getCategoryIcon(pet.category),
                          const SizedBox(width: 6),
                          Text(
                            pet.breed,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      })
    );
  }

  Widget _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case "dog":
        return const Text("🐶", style: TextStyle(fontSize: 20));
      case "cat":
        return const Text("🐱", style: TextStyle(fontSize: 20));
      case "bird":
        return const Text("🐦", style: TextStyle(fontSize: 20));
      case "rabbit":
        return const Text("🐰", style: TextStyle(fontSize: 20));
      case "fish":
        return const Text("🐠", style: TextStyle(fontSize: 20));
      default:
        return const Text("🔹", style: TextStyle(fontSize: 20)); // Fallback emoji
    }
  }


}