import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
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
        identifier TEXT NOT NULL
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
      });
    }
  }

  Future<List<Map<String, dynamic>>> getPets() async {
    final db = await database;
    return await db.query(tableName);
  }
}
