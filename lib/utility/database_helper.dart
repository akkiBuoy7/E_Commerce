import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../ui/model/order_item.dart';
import '../ui/model/product_item.dart';

class DataBaseHelper {
  String productTable = 'product_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPrice = 'price';
  String colDate = 'date';

  String orderTable = 'order_table';
  String ordercolId = 'order_id';
  String ordercolTitle = 'order_title';
  String ordercolDescription = 'order_description';
  String ordercolPrice = 'order_price';
  String ordercolDate = 'order_date';

  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;
  static Database? _database;

  static final DataBaseHelper instance = DataBaseHelper();

  Future<Database?> get database async {
    _database ??= await initialiseDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  initialiseDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDb,
    );
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''CREATE TABLE $productTable (
        $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $colTitle TEXT, 
        $colDescription TEXT, 
        $colPrice INTEGER, 
        $colDate TEXT
        )
        ''');

    await db.execute('''CREATE TABLE $orderTable (
        $ordercolId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $ordercolTitle TEXT, 
        $ordercolDescription TEXT, 
        $ordercolPrice INTEGER, 
        $ordercolDate TEXT
        )
        ''');
  }

  Future<List<Map<String, dynamic>>?> getProductMapList() async {
//		var result = await db.rawQuery('SELECT * FROM $productTable order by $colPriority ASC');
    Database? db = await instance.database;
    var result = await db!.query(productTable, orderBy: '$colPrice ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>?> getOrderMapList() async {
    Database? db = await instance.database;
    var result = await db!.query(orderTable, orderBy: '$ordercolPrice ASC');
    return result;
  }

  Future<int> insertProduct(Product product) async {
    Database? db = await instance.database;
    debugPrint("**********${db}");
    var result = await db!.insert(productTable, product.toMap());
    return result;
  }


  Future<int> insertOrder(OrderItem order) async {
    Database? db = await instance.database;
    debugPrint("**********${db}");
    var result = await db!.insert(orderTable, order.toMap());
    return result;
  }

  // Update Operation: Update a product object and save it to database
  Future<int> updateProduct(Product product) async {
    Database? db = await instance.database;
    var result = await db!.update(productTable, product.toMap(),
        where: '$colId = ?', whereArgs: [product.id]);
    return result;
  }

  Future<int?> deleteProduct(int? id) async {
    Database? db = await instance.database;

    int? result =
        await db!.rawDelete('DELETE FROM $productTable WHERE $colId = $id');
    return result;
  }

  // Get number of product objects in database
  Future<int?> getCount() async {
    Database? db = await instance.database;

    List<Map<String, Object?>>? x =
        await db!.rawQuery('SELECT COUNT (*) from $productTable');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'product List' [ List<product> ]
  Future<List<Product>> getProductList() async {
    var productMapList = await getProductMapList(); // Get 'Map List' from database
    int? count =
        productMapList?.length; // Count the number of map entries in db table

    List<Product> productList = <Product>[];
    // For loop to create a 'product List' from a 'Map List'
    for (int i = 0; i < count!; i++) {
      productList.add(Product.fromMap(productMapList![i]));
    }

    return productList;
  }

  Future<List<OrderItem>> getOrderList() async {
    var orderMapList = await getOrderMapList(); // Get 'Map List' from database
    int? count =
        orderMapList?.length; // Count the number of map entries in db table

    List<OrderItem> orderList = <OrderItem>[];
    // For loop to create a 'product List' from a 'Map List'
    for (int i = 0; i < count!; i++) {
      orderList.add(OrderItem.fromMap(orderMapList![i]));
    }

    return orderList;
  }
}
