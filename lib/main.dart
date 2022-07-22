// @dart=2.9
import'package:flutter/material.dart';
// ignore: unused_import
import 'package:note_keeper/screen/notedetail.dart';
import 'package:note_keeper/screen/notelist.dart';


void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteKeeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange
      ),
      
      home: NoteList(),
      );
  }
   // ignore: non_constant_identifier_names
  }