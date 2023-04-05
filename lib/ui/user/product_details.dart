import 'package:e_commerce/ui/model/product_item.dart';
import 'package:flutter/cupertino.dart';

class ProductDetails extends StatefulWidget {
  Product product;
  String title;

  ProductDetails(this.product, this.title);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
