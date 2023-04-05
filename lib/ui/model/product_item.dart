import 'dart:ffi';

class Product {
  int? _id=null;
  int _price=0;
  String _title="";
  String _description="";
  String _date="";

  Product(  this._title, this._date,this._price,
      [this._description = ""]);

  Product.withId(this._id, this._price, this._title, this._date,
      [this._description = ""]);

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  String get description => _description;

  set description(String value) {
    if (value.length <= 255) {
      _description = value;
    }
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  int get price => _price;

  set price(int value) {
      _price = value;
  }

  int? get id => _id;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();

    if (id != null) {
      map['id'] = _id;
    }

    map['title'] = _title;
    map['description'] = _description;
    map['price'] = _price;
    map['date'] = _date;

    return map;
  }

  Product.fromMap(Map<String,dynamic> map){
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._price = map['price'];
    this._date = map['date'];
  }
}
