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
      appBar: AppBar(title: Text('Pets List')),
      body: pets.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => PetDetailPage(pet: pets[index])));
                  },
                  child: ListTile(
                    leading: Image.network(
                      pets[index].imageUrl, // ['image_url'], 
                      width: 50, 
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.pets, size: 50, color: Colors.grey);
                      },
                    ),
                    title: Text(pets[index].name), //['name']),
                    subtitle: Text("${pets[index].breed} - ${pets[index].category}"),
                    trailing: Text("\$${pets[index].price}"),
                  ),
                );
              },
            ),
    );
  }
}