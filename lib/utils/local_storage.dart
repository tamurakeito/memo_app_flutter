import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'dart:convert';

late Database database;

Future<Database> initializeDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'data.db');

  return openDatabase(
    path,
    version: 3,
    onCreate: (db, version) async {
      final initSql = await rootBundle.loadString('assets/sql/init.sql');
      await db.execute(initSql);
    },
  );
}

Future<void> insertItem(Database db, String name, String quantity) async {
  await db.insert(
    'items',
    {'name': name, 'quantity': quantity},
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Map<String, dynamic>>> fetchItems(Database db) async {
  return await db.query('items');
}

Future<void> updateItem(Database db, int id, String name, int quantity) async {
  await db.update(
    'items',
    {'name': name, 'quantity': quantity},
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<void> deleteItem(Database db, int id) async {
  await db.delete(
    'items',
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<void> insertItemWithArray(
    Database db, String name, List<int> quantities) async {
  final jsonQuantities = jsonEncode(quantities);

  await db.insert(
    'items',
    {'name': name, 'quantities': jsonQuantities},
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
