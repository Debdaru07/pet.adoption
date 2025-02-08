import 'dart:async';

import 'package:flutter/material.dart';

import '../models/pet_model.dart';
import '../services/db_services.dart';

class PetsViewModel extends ChangeNotifier {
  List<PetModel> _allPets = [];
  List<PetModel> get allPets => _allPets;
  setAllPetsValue(List<PetModel> val) {
    _allPets = val;
    notifyListeners();
  }

  getPetsAsListOfPetModel() async { 
    var pets = await DatabaseHelper.instance.getPetsAsListOfPetModel();
    setAllPetsValue(pets);
  }

  List<PetModel> _adoptedPets = [];
  List<PetModel> get fetchPets => _adoptedPets;

  setAdoptedPets(List<PetModel> val) {
    _adoptedPets = val;
    notifyListeners();
  }

  callAdoptedPets() async {
    var pets = await DatabaseHelper.instance.getAdoptedPetsChronologically();
    setAllPetsValue(pets);
  }

  debounceSearchDBService(String searchString) {
    if (searchString.isEmpty) return allPets;
    searchString = searchString.toLowerCase();
    final result = allPets.where((pet) {
      return pet.name.toLowerCase().contains(searchString) ||
            pet.breed.toLowerCase().contains(searchString) ||
            pet.category.toLowerCase().contains(searchString) ||
            pet.identifier.toLowerCase().contains(searchString) ||
            pet.age.toString().contains(searchString) ||
            pet.price.toString().contains(searchString);
    }).toList();
    setAllPetsValue(result);
  }

  Timer? _debounce;
  final TextEditingController searchController = TextEditingController();
  Timer? get debounce => _debounce;

  set debounce(Timer? timer) {
    _debounce?.cancel();
    _debounce = timer;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }



}