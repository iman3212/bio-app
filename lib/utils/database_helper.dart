import 'dart:async';
import 'dart:io';

import '../model/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String table = 'record_table';
  String colId = 'id';
  String colDesc = 'desc';
  var colTime = 'time';
  var colData = 'data';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null)
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) _database = await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'records.db';

    // Open/create the database at a given path
    var todosDatabase =
    await openDatabase(path, version: 1, onCreate: _createDb);
    return todosDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $table($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colDesc TEXT, '
            '$colTime TEXT, $colData TEXT)');
  }

//   Future<List<Map<String, dynamic>>> getTimesMapList(String sbj) async {
//     Database db = await this.database;
//
//     var result = await db.rawQuery(
//         'SELECT * FROM $table where $colSbj=\'$sbj\' AND $colDesc !=\'\'');
// //    var result = await db.query(todoTable, where: '$colSbj = taha');
//     return result;
//   }

  Future<int> insert(Record record) async {
    Database db = await this.database;
    var result = await db.insert(table, record.toMap());
    return result;
  }

  // // Update Operation: Update a todo object and save it to database
  // Future<int> updateTodo(Record record) async {
  //   var db = await this.database;
  //   var result = await db.update(table, record.toMap(),
  //       where: '$colId = ?', whereArgs: [record.id]);
  //   return result;
  // }

  Future<int> deleteAll() async {
    var db = await this.database;
    int result =
    await db.rawDelete('DELETE FROM $table');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
    await db.rawQuery('SELECT COUNT (*) from $table');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Map<String, dynamic>>> _getRecordMapList() async {
    Database db = await this.database;

    var result = await db.rawQuery(
        'SELECT * FROM $table ');

    return result;
  }

  Future<List<Record>> getRecordList() async {
    var todoMapList = await _getRecordMapList(); // Get 'Map List' from database
    int count =
        todoMapList.length; // Count the number of map entries in db table

    List<Record> todoList = List<Record>();
    for (int i = 0; i < count; i++) {
      todoList.add(Record.fromMapObject(todoMapList[i]));
    }

    return todoList;
  }


}
