import 'package:flutter/material.dart';

import '../models/pet_model.dart';

class PetDetailPage extends StatelessWidget {
  final PetModel pet;

  const PetDetailPage({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              pet.imageUrl,
              height: 400,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 16),
            Text('Name: ${pet.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Breed: ${pet.breed}'),
            Text('Category: ${pet.category}'),
            Text('Age: ${pet.age} years'),
            Text('Price: \$${pet.price.toStringAsFixed(2)}'), 
            if (pet.adoptedDate!= null)
              Text('Adopted Date: ${pet.adoptedDate}'),
            Text('Identifier: ${pet.identifier}'),
            Text('Contact At: ${pet.contactAt}'),
            Text('Collect Pet From: ${pet.collectPetFrom}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAdoptionConfirmationDialog(context);
        },
        child: const Text("Adopt Me"), 
      ),
    );
  }

  void _showAdoptionConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Adoption"),
          content: Text("Are you sure you want to adopt ${pet.name}?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Adopt"),
              onPressed: () {
                // Perform adoption actions here (e.g., database update)
                //...
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${pet.name} adopted!')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}