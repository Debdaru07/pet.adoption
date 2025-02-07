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
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                // Positioned(
                //   top: 8,
                //   right: 8,
                //   child: IconButton(
                //     icon: const Icon(Icons.favorite_border, color: Colors.white),
                //     onPressed: () {
                //       // Add favorite functionality
                //     },
                //   ),
                // ),
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