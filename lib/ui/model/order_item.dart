import 'dart:ffi';

class OrderItem {
  int? _id=null;
  int _price=0;
  String _title="";
  String _description="";
  String _date="";

  OrderItem(  this._title, this._date,this._price,
      [this._description = ""]);

  OrderItem.withId(this._id, this._price, this._title, this._date,
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
      map['order_id'] = _id;
    }

    map['order_title'] = _title;
    map['order_description'] = _description;
    map['order_price'] = _price;
    map['order_date'] = _date;

    return map;
  }

  OrderItem.fromMap(Map<String,dynamic> map){
    this._id = map['order_id'];
    this._title = map['order_title'];
    this._description = map['order_description'];
    this._price = map['order_price'];
    this._date = map['order_date'];
  }
}
