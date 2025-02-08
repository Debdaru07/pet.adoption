import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/pet_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  final String tableName = "pets";

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pets_database.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, fileName);
      return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
      );
    } catch(obj) {
      log('exception :- $obj');
      return await openDatabase(
        '',
        version: 1,
        onCreate: _createDB,
      );
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER NOT NULL,
        price REAL NOT NULL,
        image_url TEXT NOT NULL,
        breed TEXT NOT NULL,
        category TEXT NOT NULL,
        adopted_date TEXT,
        identifier TEXT NOT NULL,
        contact_at TEXT NOT NULL DEFAULT 'Not Provided',
        collect_pet_from TEXT NOT NULL
      )

    ''');

    await _populateDatabase(db);
  }

  Future<void> _populateDatabase(Database db) async {
    String jsonData = await rootBundle.loadString('assets/pets.json');
    List<dynamic> petsList = json.decode(jsonData);

    for (var pet in petsList) {
      await db.insert(tableName, {
        "name": pet["name"],
        "age": pet["age"],
        "price": pet["price"],
        "image_url": pet["image_url"],
        "breed": pet["breed"],
        "category": pet["category"],
        "adopted_date": pet["adopted_date"],
        "identifier": pet["identifier"],
        "contact_at": pet["contact_at"],
        "collect_pet_from": pet["collect_pet_from"],
      });
    }
  }

  Future<List<Map<String, dynamic>>> getPets() async {
    final db = await database;
    return await db.query(tableName);
  }
  Future<List<PetModel>> getPetsAsListOfPetModel() async { 
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return PetModel.fromJson(maps[i]);
    });
  }

  Future<List<PetModel>> getAdoptedPetsChronologically() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: "adopted_date IS NOT NULL AND adopted_date != ''",
      orderBy: "adopted_date DESC", // Sorting in chronological order
    );
    return List.generate(maps.length, (i) {
      return PetModel.fromJson(maps[i]);
    });
  }

  Future<bool> updateAdoptionDate(int petId,) async {
    final db = await database;
    int response = await db.update(
      tableName,
      {"adopted_date": DateTime.now().toUtc().toIso8601String()},
      where: "id = ?",
      whereArgs: [petId],
    );
    return response == 1;
  }

  Future<PetModel?> getPetById(int petId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: "id = ?",
      whereArgs: [petId],
    );

    if (maps.isNotEmpty) {
      return PetModel.fromJson(maps.first);
    }
    return null;
  }

}
