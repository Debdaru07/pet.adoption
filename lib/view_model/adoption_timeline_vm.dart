import 'package:flutter/material.dart';

import '../models/pet_model.dart';
import '../services/db_services.dart';

class AdoptionTimelineVm extends ChangeNotifier {
  List<PetModel> _pets = [];
  List<PetModel> get fetchPets => _pets;

  setPets(List<PetModel> val) {
    _pets = val;
    notifyListeners();
  }

  callAdoptedPets() async {
    var pets = await DatabaseHelper.instance.getAdoptedPetsChronologically();
    setPets(pets);
  }
  
}