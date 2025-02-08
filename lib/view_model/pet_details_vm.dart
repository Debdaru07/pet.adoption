import 'package:flutter/material.dart';

import '../models/pet_model.dart';
import '../services/db_services.dart';

class PetDetailsVm extends ChangeNotifier {
  PetModel? _model;
  PetModel? get model => _model;

  setPetDetailsModel(PetModel? val) {
    _model = val;
    notifyListeners();
  }

  callIndividualPet(int id) async {
    final response = await DatabaseHelper.instance.getPetById(id);
    setPetDetailsModel(response);
  }
}