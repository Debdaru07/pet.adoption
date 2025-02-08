import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pet_adoption/models/pet_model.dart';
import 'package:pet_adoption/services/db_services.dart';
import 'package:sqflite/sqflite.dart';
import 'database_helper_test.mocks.dart';

// Generate mock classes
@GenerateMocks([Database])
void main() {
  late DatabaseHelper databaseHelper;
  late MockDatabase mockDatabase;

  setUp(() {
    databaseHelper = DatabaseHelper.instance;
    mockDatabase = MockDatabase();
  });

  group("DatabaseHelper Tests", () {
    test("getPets should return list of pets", () async {
      // Mock response data
      when(mockDatabase.query(any)).thenAnswer((_) async => [
        {
          "id": 1,
          "name": "Charlie",
          "age": 2,
          "price": 100.0,
          "image_url": "https://example.com/dog.jpg",
          "breed": "Labrador",
          "category": "Dog",
          "adopted_date": null,
          "identifier": "1234",
          "contact_at": "Not Provided",
          "collect_pet_from": "XYZ Shelter"
        }
      ]);

      // Call method
      final pets = await databaseHelper.getPetsAsListOfPetModel();

      // Verify expectations
      expect(pets, isA<List<PetModel>>());
      expect(pets.length, 1);
      expect(pets.first.name, "Charlie");
    });

    test("getPetById should return a pet", () async {
      when(mockDatabase.query(any, where: anyNamed("where"), whereArgs: anyNamed("whereArgs")))
          .thenAnswer((_) async => [
        {
          "id": 1,
          "name": "Charlie",
          "age": 2,
          "price": 100.0,
          "image_url": "https://example.com/dog.jpg",
          "breed": "Labrador",
          "category": "Dog",
          "adopted_date": null,
          "identifier": "1234",
          "contact_at": "Not Provided",
          "collect_pet_from": "XYZ Shelter"
        }
      ]);

      final pet = await databaseHelper.getPetById(1);

      expect(pet, isNotNull);
      expect(pet?.name, "Charlie");
    });

    test("updateAdoptionDate should return true if update succeeds", () async {
      when(mockDatabase.update(any, any, where: anyNamed("where"), whereArgs: anyNamed("whereArgs")))
          .thenAnswer((_) async => 1);
      final result = await databaseHelper.updateAdoptionDate(1);
      expect(result, true);
    });

    test("getAdoptedPetsChronologically should return sorted pets", () async {
      when(mockDatabase.query(
        any,
        where: anyNamed("where"),
        orderBy: anyNamed("orderBy"),
      )).thenAnswer((_) async => [
        {
          "id": 1,
          "name": "Charlie",
          "adopted_date": "2025-02-01T12:00:00Z",
        },
        {
          "id": 2,
          "name": "Bella",
          "adopted_date": "2025-02-05T12:00:00Z",
        }
      ]);

      final pets = await databaseHelper.getAdoptedPetsChronologically();
      expect(pets.length, 2);
      expect(pets.first.name, "Bella"); // Sorted by adopted_date DESC
    });
  });
}
