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

  final List<PetModel> _visiblePets = [];
  int _currentPage = 0;
  int _itemsPerPage = 6;

  List<PetModel> get visiblePets => _visiblePets;
  int get itemsPerPage => _itemsPerPage;

  void setPets(List<PetModel> pets) {
    _allPets.clear();
    _allPets.addAll(pets);
    _currentPage = 0;
    _loadNextPage();
  }

  void setItemsPerPage(int items) {
    _itemsPerPage = items;
    _currentPage = 0;
    _visiblePets.clear();
    _loadNextPage();
    notifyListeners();
  }

  void _loadNextPage() {
    int startIndex = _currentPage * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;

    if (startIndex < _allPets.length) {
      _visiblePets.addAll(_allPets.sublist(
          startIndex, endIndex > _allPets.length ? _allPets.length : endIndex));
      _currentPage++;
      notifyListeners();
    }
  }

  void loadMore() {
    if (_currentPage * _itemsPerPage < _allPets.length) {
      _loadNextPage();
    }
  }

  List<PetModel> _adoptedPets = [];
  List<PetModel> get fetchPets => _adoptedPets;

  setAdoptedPets(List<PetModel> val) {
    _adoptedPets = val;
    notifyListeners();
  }

  callAdoptedPets() async {
    var pets = await DatabaseHelper.instance.getAdoptedPetsChronologically();
    setPets(pets);
  }



}