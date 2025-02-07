import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_list/timeline_list.dart';
import '../models/pet_model.dart';
import '../view_model/adoption_timeline_vm.dart';

class AdoptedPetsTimelineScreen extends StatefulWidget {
  const AdoptedPetsTimelineScreen({super.key});

  @override
  _AdoptedPetsTimelineScreenState createState() => _AdoptedPetsTimelineScreenState();
}

class _AdoptedPetsTimelineScreenState extends State<AdoptedPetsTimelineScreen> {

  @override
  void initState() {
    super.initState();
    try {
      Future.delayed(Duration.zero, () async {
        final petViewModel = Provider.of<AdoptionTimelineVm>(context, listen: false);
        petViewModel.callAdoptedPets();
      });
    } catch(obj) {
      log('obj :- $obj');
    }
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: Text("Adopted Pets Timeline"),
      ),
      body: Consumer<AdoptionTimelineVm>(
        builder: (context, viewModel, _) {
          try {
            return Timeline.builder(
              context: context,
              markerCount: viewModel.fetchPets.length,
              markerBuilder: (context, index) {
                final pet = viewModel.fetchPets[index];

                return Marker(
                  child: _buildPetCard(pet)
                ); 
              },
            );
          } catch(obj) {
            return const SizedBox.shrink();
          }
          
        },
      ),
    );
  }

  Widget _buildPetCard(PetModel pet) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pet.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text("Breed: ${pet.breed}", style: TextStyle(fontSize: 14)),
            Text("Age: ${pet.age} years", style: TextStyle(fontSize: 14)),
            SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: Colors.blue),
                SizedBox(width: 4),
                Text(pet.contactAt, style: TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
