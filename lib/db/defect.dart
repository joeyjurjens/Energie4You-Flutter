import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:energie4you/model/defect.dart';

class DefectDatabase {
  static final DefectDatabase instance = DefectDatabase._init();

  static Database? _database;

  DefectDatabase._init();

  Future<Database> get database async {
    if(_database != null) return _database!;

    _database = await _initDB("defect.db");
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final stringType = 'TEXT NOT NULL';
    
    await db.execute('''
      CREATE TABLE $tableDefect (
        ${DefectFields.id} $idType,
        ${DefectFields.imagePath} $stringType,
        ${DefectFields.gps_coordinates} $stringType,
        ${DefectFields.mechanic_name} $stringType,
        ${DefectFields.description} $stringType,
        ${DefectFields.categorie} $stringType)
    ''');
  }

  Future<Defect> create(Defect defect) async {
    final db = await instance.database;
    final id = await db.insert(tableDefect, defect.toJson());
    return defect.copy(id: id);
  }

  Future<Defect?> readDefect(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableDefect,
      columns: DefectFields.values,
      where: '${DefectFields.id} = ?',
      whereArgs: [id],
    );

    if(maps.isNotEmpty) {
      return Defect.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Defect>> readCategorieDefects(String categorie) async {
    final db = await instance.database;
    final results = await db.rawQuery("SELECT * FROM ${tableDefect} WHERE ${DefectFields.categorie}='${categorie}'");
    return results.map((json) => Defect.fromJson(json)).toList();
  }

  Future<List<Map<String, Object?>>> readAllCategories() async {
    final db = await instance.database;
    final results = await db.rawQuery("SELECT ${DefectFields.id}, ${DefectFields.categorie} FROM ${tableDefect} GROUP BY ${DefectFields.categorie};");
    return results;
  }  

  Future<int> update(Defect defect) async {
    final db = await instance.database;
    return db.update(
      tableDefect,
      defect.toJson(),
      where: '${DefectFields.id} = ?',
      whereArgs: [defect.id]
    );
  }

  Future<int> delete(Defect defect) async {
    final db = await instance.database;
    return await db.delete(
      tableDefect,
      where: '${DefectFields.id} = ?',
      whereArgs: [defect.id]
    );
  }

  Future closeDB() async {
    final db = await instance.database;
    db.close();
  }
}