import 'package:e_commerce/ui/model/order_item.dart';
import 'package:flutter/material.dart';

import '../../services/pref_service.dart';
import '../../utility/database_helper.dart';

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {

  late List<OrderItem> orderList = [];
  final dataBaseHelper = DataBaseHelper();
  int listCount = 0;
  var prefService = PrefService();


  @override
  Widget build(BuildContext context) {

    updateListView();

    return Scaffold(
      appBar: AppBar(
        title: Text("Order"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: _logOut
          )
        ],
      ),
      body: getOrderListUi(),
    );
  }


  void _logOut(){

   prefService.clearUser();

  }

  ListView getOrderListUi() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          elevation: 2,
          child: ListTile(
              title: Text(orderList[index].title),
              subtitle: Text(orderList[index].description),),
        );
      },
      itemCount: listCount,
    );
  }

  void updateListView() {
    Future<List<OrderItem>> orderListFuture = dataBaseHelper.getOrderList();
    orderListFuture.then((noteList) {
      setState(() {
        this.orderList = noteList;
        listCount = noteList.length;
      });
    });
  }
}
