import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/pref_service.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Products Listing"),
      ),
      body: Center(
          child: Text(
        _userType,
        style: TextStyle(fontSize: 70),
      )),
      floatingActionButton: _isAdmin?FloatingActionButton(onPressed: (){

      },child: Text("Add Product"),):Container(),
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
}
