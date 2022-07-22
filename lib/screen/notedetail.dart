import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';
 
// ignore: unused_import
import 'dart:async';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';



// ignore: must_be_immutable
class NoteDetail extends StatefulWidget{
  final String appBarTitle;
  final Note note;
  NoteDetail(this.note,this.appBarTitle);
  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note,this.appBarTitle);
  }

}
class NoteDetailState extends State<NoteDetail>{
 final String appBarTitle;
  final Note note;
  static var _priorities =['High','Low'];
  DatabaseHelper helper = DatabaseHelper();
  TextEditingController titleControler =TextEditingController();
   TextEditingController descriptionControler =TextEditingController();
   NoteDetailState(this.note,this.appBarTitle);
  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.headline6;
    titleControler.text = note.title;
     descriptionControler.text = note.description ?? '';
    return WillPopScope(
      onWillPop: ()async {
         moveToLastScreen();
         return true;
        
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(icon: Icon(Icons.arrow_left),
          onPressed: (){
            moveToLastScreen();
          },),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0,left:10.0,right:10.0),
          child: ListView(
            children:<Widget> [
              ListTile(
                title: DropdownButton(items: _priorities.map((String dropDownStringItem){
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),);
                }).toList(),
                style: textStyle,
                value: getPriorityAsString(note.priority),
                onChanged:(valueSelectByUser) {
    setState(() {
     print( ' user selected $valueSelectByUser');
     updatePriorityAsInt(valueSelectByUser.toString());
    });
                },),
              ),
              Padding(padding: EdgeInsets.only(top: 15.0,bottom:15.0),
              child: TextField(
                controller: titleControler,
                style: textStyle,
                onChanged: (value){
                updateTitle();
                },
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle:textStyle,
                  border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)
                  )
    
                ),
              ),
              ),
              Padding(padding: EdgeInsets.only(top: 15.0,bottom:15.0),
              child: TextFormField(
                controller: descriptionControler,
                style: textStyle,
                onChanged: (value){
                updateDescription();
                },
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle:textStyle,
                  border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)
                  )
    
                ),
              ),
              ),
              Padding(padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
              child:Row(children:<Widget> [
                Expanded(
                  // ignore: deprecated_member_use
                  child:RaisedButton(
                    color:Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).primaryColorLight,
                    child:Text('Save',
                    textScaleFactor: 1.5,
                    ),
                    onPressed: (){
                      setState(() {
                        _save();
                      });
                    },
                    )
    
    
                ),
                Container(width:5.0),
                Expanded(
                  // ignore: deprecated_member_use
                  child:RaisedButton(
                    color:Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).primaryColorLight,
                    child:Text('Delete',
                    textScaleFactor: 1.5,
                    ),
                    onPressed: (){
                      setState(() {
                        _delete();
                      });
                    },
                    )
    
    
                )
              ],))
            ],
          ),
        ),
    
      ));
    
  }
  void moveToLastScreen(){
    Navigator.pop(context, true);
  }
// convert the String Priority in the form of integer before saving it to database
void updatePriorityAsInt(String? value){
  switch(value){
    case'High':
    note.priority =1;
    break;
    case 'Low':
    note.priority=2;
    break;
  }
}
//convert int priority to String priority and display it to user in DropDown
String? getPriorityAsString(int value){
  String? priority;
  switch(value){
    case 1:
    priority = _priorities[0];
    break;
    case 2:
    priority =_priorities[1];
    break;
  }
  return priority;
}
//update the title of note object
void updateTitle(){
  note.title =titleControler.text;
}
//update the description of note object
void updateDescription(){
  note.description=descriptionControler.text;
}
void _save() async{
  moveToLastScreen();
  note.date =DateFormat.yMMMd().format(DateTime.now());
  int result;
  
  
  
  // ignore: unnecessary_null_comparison
  if(note.id != null){
    result= await helper.updateNote(note);
    }else{
result= await helper.insertNote(note);
    
  }
  if(result !=0){
_showAlertDialog('status','Saved Successfully');
  }else{
_showAlertDialog('status','Problem Saving Note');
  }
}
void _delete() async{
  moveToLastScreen();
 
  // ignore: unnecessary_null_comparison
  if(note.id == null){
    _showAlertDialog('Status', "No note was Deleted");
    return;
  }
  int result = await helper.deleteNote(note.id);
  if (result !=0){
    _showAlertDialog('Status', "Note DEleted Successfully");
  }else{
    _showAlertDialog('Status', 'Error Occured While Deleting');
  }
}
void _showAlertDialog(String title, String message){
  AlertDialog alertDialog =AlertDialog(
    title:Text(title),
    content:Text(message),
  );
  showDialog(context: context, builder: (_) => alertDialog);
}
}