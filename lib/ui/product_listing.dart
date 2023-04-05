import 'package:e_commerce/ui/admin/add_product.dart';
import 'package:e_commerce/ui/model/product_item.dart';
import 'package:e_commerce/ui/user/orders.dart';
import 'package:flutter/material.dart';

import '../services/pref_service.dart';
import '../utility/database_helper.dart';
import 'model/user.dart';

class ProductListing extends StatefulWidget {
  const ProductListing({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductListing> createState() => _ProductListingState();
}

class _ProductListingState extends State<ProductListing> {
  var prefService = PrefService();
  bool _isAdmin = false;
  String _userType = "";
  int listCount = 0;
  late List<Product> productList = [];
  final dataBaseHelper = DataBaseHelper();
  var args;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    updateListView();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Products Listing"),
        actions: <Widget>[
          _isAdmin
              ? Container()
              : IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new Order(),
                      ),
                    );
                  },
                )
        ],
      ),
      body: getProductListUi(),
      floatingActionButton: _isAdmin
          ? FloatingActionButton(
              onPressed: () {
                navigateToDetail(Product('', '', 0), 'Add Product');
              },
              child: Icon(Icons.add),
            )
          : Container(),
    );
  }

  ListView getProductListUi() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          elevation: 2,
          child: ListTile(
              title: Text(productList[index].title),
              subtitle: Text(productList[index].description),
              trailing: _isAdmin
                  ? IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _delete(context, productList[index]);
                      })
                  : ElevatedButton(
                      onPressed: () {
                        navigateToDetail(this.productList[index], "View Products");
                      },
                      child: Text("Order")),
              onTap: () {
                debugPrint("list tile tapped");
                var title = _isAdmin ? "Add Product" : "View Products";
                navigateToDetail(this.productList[index], title);
              }),
        );
      },
      itemCount: listCount,
    );
  }

  void _loadProfile() async {
    try {
      User userData = await prefService.getUser();
      _isAdmin = userData.isAdmin ?? false;

      print("**********Profile $_isAdmin***********");

      if (_isAdmin) {
        setState(() {
          _userType = "ADMIN";
        });
      } else {
        setState(() {
          _userType = "USER";
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _delete(BuildContext context, Product product) async {
    int? result = await dataBaseHelper.deleteProduct(product.id);
    if (result != 0) {
      _showSnackBar(context, 'Product Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    Future<List<Product>> productListFuture = dataBaseHelper.getProductList();
    productListFuture.then((productList) {
      setState(() {
        this.productList = productList;
        listCount = productList.length;
      });
    });
  }

  void navigateToDetail(Product product, String title) async {
    if (_isAdmin) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AddProduct(product, title, _isAdmin);
      }));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return AddProduct(product, title, _isAdmin);
      }));
    }
  }
}
