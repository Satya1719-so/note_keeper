

class Note{
 late int _id;
 late String _title;
 late String? _description;
 late String _date;
 late int _priority;
  Note (this._title,this._date,this._priority, [this._description]);

  Note.withId(this._id,this._title,this._date,this._priority,[this._description]);
  int get id => _id;
  String get title => _title;
  String? get description => _description;
  int get priority => _priority;
  String get date =>_date;

  set title(String newTitle){
    if(newTitle.length<=25){
      this._title=newTitle;
    }
  }
  set description(String? newDescription){
    if(newDescription!.length <= 255){
      this._description=newDescription;
}
  }
  set priority(int newPriority){
    if (newPriority >= 1 && newPriority <= 2){
      this._priority=newPriority;
    }
  }
  set date (String newDate){
    this._date=newDate;
  }
  //convert a note object into map
  Map<String, dynamic>toMap() {
    var map =Map<String, dynamic>();
    // ignore: unnecessary_null_comparison
    if(id != null){
      map['id']= _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date']=_date;
    return map;

  }
  Note.fromMapObject(Map<String,dynamic>map){
    
    this._id=map['id'];
    this._title=map['title'];
    this._description=map['description'];
    this._priority=map['priority'];
    this._date=map['date'];
  }
  }