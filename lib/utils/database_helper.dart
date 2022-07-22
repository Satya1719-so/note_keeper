import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:note_keeper/models/note.dart';

class DatabaseHelper{
  static DatabaseHelper? _databaseHelper; //Singleton database helper
  static Database? _database;
  String noteTable ='note_table';
  String colId ='id';
  String colTitle ='title';
  String colDescription ='description';
  String colPriority ='priority';
  String colDate ='date';
  DatabaseHelper._createInstance();
  factory DatabaseHelper(){
    if(_databaseHelper == null){
      _databaseHelper= DatabaseHelper._createInstance();
    }

    return _databaseHelper!;
  }
  Future<Database> get database async{
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database!;
  }

  
  Future<Database>initializeDatabase() async{
    //get the directory path for both android and ios to store database,
    Directory directory =await getApplicationSupportDirectory();
    String path =directory.path + 'notes.db';
    //open/create the database at a given path
    var notesDatabase=await openDatabase(path, version: 1,onCreate: _createDb,);
    return notesDatabase;
  }
  void _createDb(Database db,int newVersion) async{
    await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT,'
    '$colDescription TEXT,$colPriority INTEGER,$colDate TEXT)');
  }
Future<List<Map<String,dynamic>>> getNoteMapList() async{
  Database db =await this.database;
  var result = await db.query(noteTable,orderBy:'$colPriority ASC');
  return result;
}
Future<int>insertNote(Note note) async{
  Database db = await this.database;
  var result = await db.insert(noteTable,note.toMap());
  return result;
}
Future<int>updateNote(Note note) async{
  var db = await this.database;
  var result = await db.update(noteTable,note.toMap(),where:'$colId=?',whereArgs:[note.id]);
  return result;
}
Future<int>deleteNote(int id) async{
  var db = await this.database;
  var result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId=$id');
  return result;
}
//get number of notes objects in database
Future<int?>getCount() async {
  Database db =await this.database;
  List<Map<String,dynamic>> x = await db.query(noteTable);
  int? result =Sqflite.firstIntValue(x);
  return result!;
}
Future<List<Note>>getNoteList() async{
var noteMapList = await getNoteMapList();
int count = noteMapList.length;
List<Note> noteList = [];
for (int i =0; i < count; i++){
  noteList.add(Note.fromMapObject(noteMapList[i]));
}
return noteList;
}

}