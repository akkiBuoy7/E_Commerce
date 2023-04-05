import 'package:e_commerce/ui/model/order_item.dart';
import 'package:e_commerce/ui/model/product_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/pref_service.dart';
import '../../utility/database_helper.dart';
import '../model/user.dart';

class AddProduct extends StatefulWidget {
  Product product;
  String title;
  bool _isAdmin = false;

  AddProduct(this.product, this.title,this._isAdmin);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  static var _prices = [100, 200, 300, 400, 500];
  int _dropDownValue = _prices.first;
  var titleController = TextEditingController();
  var descController = TextEditingController();

  var prefService = PrefService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    titleController.text = widget.product.title;
    descController.text = widget.product.description;

    // _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: DropdownButton<int>(
                value: widget.product.price == 0
                    ? _dropDownValue
                    : widget.product.price,
                icon: const Icon(
                  Icons.arrow_drop_down_circle_outlined,
                  color: Colors.blue,
                ),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: widget._isAdmin
                    ? (int? valueSelected) {
                        // This is called when the user selects an item.
                        setState(() {
                          _dropDownValue = valueSelected!;
                          widget.product.price = _dropDownValue;
                        });
                      }
                    : null,
                items: _prices.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20),
              child: TextField(
                enabled: widget._isAdmin ? true : false,
                controller: titleController,
                decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter Title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                onChanged: (value) {
                  updateTitle();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: TextField(
                enabled: widget._isAdmin ? true : false,
                controller: descController,
                decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                onChanged: (value) {
                  updateDescription();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          widget._isAdmin ? _save() : _placeOrder(widget.product);
                          debugPrint("Saved clicked");
                        },
                        child: widget._isAdmin ? Text('Save') : Text("Place order")),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: 20,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Visibility(
                        visible: widget._isAdmin ? true : false,
                        child: ElevatedButton(
                            onPressed: () {
                              debugPrint("Delete clicked");
                              _delete();
                            },
                            child: Text('Delete')),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
    ;
  }

  // Update the title of Note object
  void updateTitle() {
    widget.product.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    widget.product.description = descController.text;
  }

  // Save data to database
  void _save() async {
    widget.product.date = DateFormat.yMMMd().format(DateTime.now());
    int? result;
    if (widget.product.id != null) {
      // Case 1: Update operation
      result = await DataBaseHelper.instance.updateProduct(widget.product);
    } else {
      // Case 2: Insert Operation
      result = await DataBaseHelper.instance.insertProduct(widget.product);
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }

    moveToLastScreen();
  }

  void _delete() async {
    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (widget.product.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int? result =
        await DataBaseHelper.instance.deleteProduct(widget.product.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Product Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occurred while Deleting Product');
    }
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
    //Navigator.popAndPushNamed(context, ProjectUtil.LIST_ROUTE,arguments:true);
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _placeOrder(Product product)  async{
    int? result;
    result = await DataBaseHelper.instance.insertOrder(
      OrderItem(product.title, product.date, product.price,product.description)
    );

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Order Placed Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Placing Order');
    }
  }

  // void _loadProfile() async {
  //   try {
  //     User userData = await prefService.getUser();
  //     _isAdmin = userData.isAdmin ?? false;
  //
  //     print("**********Profile $_isAdmin***********");
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
