import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeline_list/timeline_list.dart';
import '../models/pet_model.dart';
import '../view_model/adoption_timeline_vm.dart';
import 'package:journey_stepper/journey_stepper.dart';

class AdoptedPetsTimelineScreen extends StatefulWidget {
  const AdoptedPetsTimelineScreen({super.key});

  @override
  _AdoptedPetsTimelineScreenState createState() => _AdoptedPetsTimelineScreenState();
}

class _AdoptedPetsTimelineScreenState extends State<AdoptedPetsTimelineScreen> {

  @override
  void initState() {
    super.initState();
    final petViewModel = Provider.of<AdoptionTimelineVm>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      await petViewModel.callAdoptedPets();
    });
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
            return ListView.builder(
              itemCount: viewModel.fetchPets.length,
              itemBuilder: (context, index) {
                final pet = viewModel.fetchPets[index];
                return JourneyStepper(
                  leftTitle: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(right: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            pet.imageUrl, 
                            width: 80, 
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8,),
                        Text(
                          formatDateString(pet.adoptedDate ?? ''),
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        
                      ],
                    ),
                  ),
                  rightTitle: _buildPetCard(pet),
                  icon: Icons.circle,
                  iconBackgroundColor: Colors.purple,
                  isLast: index == (viewModel.fetchPets.length - 1),
                  key: Key('$index'),
                );
              }
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pet.name,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text("Breed: ${pet.breed}", style: TextStyle(fontSize: 12)),
            Text("Age: ${pet.age} years", style: TextStyle(fontSize: 12)),
            SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: Colors.blue),
                SizedBox(width: 4),
                Text(pet.contactAt, style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String formatDateString(String dateTimeString) {
  try {
    DateTime parsedDate = DateTime.parse(dateTimeString);
    String day = DateFormat('d').format(parsedDate);
    String suffix = getDaySuffix(int.parse(day));
    String formattedDate = '$day$suffix ${DateFormat('MMM, yyyy').format(parsedDate)}';
    return formattedDate;
  } catch (e) {
    return 'Invalid Date Format';
  }
}

// Function to get the ordinal suffix (st, nd, rd, th)
String getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}
