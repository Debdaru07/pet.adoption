import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pet_model.dart';
import '../routes/routes.dart';
import '../view_model/pet_list_view_model.dart';
import 'pet_details.dart';

class PetListScreen extends StatefulWidget {
  const PetListScreen({super.key});

  @override
  _PetListScreenState createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {

  @override
  void initState() {
    super.initState();
    final petsVM = Provider.of<PetsViewModel>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      await petsVM.getPetsAsListOfPetModel();
      await petsVM.setAllPetsValue(petsVM.allPets);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Petadopt'),
          Spacer(),
          InkWell(
            onTap: () async {
              await Navigator.pushNamed(
                context, 
                Routes.adoptedPetsTimelineScreen, 
                arguments: {'data': 'Hello from HomeScreen'}
              );

            },
            child: Icon(Icons.timeline))
        ],
      )),
      body: Consumer<PetsViewModel>(
          builder: (context, petViewModel, child) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: petViewModel.searchController,
                decoration: InputDecoration(
                  labelText: "Search Pets",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  if(value.trim().isEmpty) {
                    final petsVM = Provider.of<PetsViewModel>(context, listen: false);
                    Future.delayed(Duration.zero, () async {
                      await petsVM.getPetsAsListOfPetModel();
                      await petsVM.setAllPetsValue(petsVM.allPets);
                    });
                  } else {
                    petViewModel.debounceSearchDBService(value);
                  }
                },
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: petViewModel.allPets.length,
                itemBuilder: (context, index) {
                  if (index < petViewModel.allPets.length) {
                    final pet = petViewModel.allPets[index];
                    return petCardIndividual(pet, index);
                  } else {
                    return petViewModel.allPets.length >= petViewModel.allPets.length
                      ? const SizedBox()
                      : const Center(child: CircularProgressIndicator());
                  }
                }
              ),
            ),
          ],
        ),
      )
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

  Widget petCardIndividual(PetModel pet, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => PetDetailPage(petId: pet.id, index: index,),
          ),

        );
      },
      child: Hero(
        tag: "hero-tag-$index",
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
      ),
    );
  }
}
