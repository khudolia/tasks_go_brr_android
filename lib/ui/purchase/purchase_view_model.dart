import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tasks_go_brr/utils/purchase_helper.dart';

class PurchaseViewModel {
  PurchaseHelper _pHelper = PurchaseHelper();

  final sAvailableProducts = StreamController<List<ProductDetails>>();

  initPurchase() async {
    await _pHelper.init();
    sAvailableProducts.sink.add(_pHelper.products);
  }

  dispose() {
    sAvailableProducts.close();
  }

  ProductDetails? getCoffeeDetails() {
    if(_pHelper.products.length >= 1)
      return _pHelper.products[0];
    else
      return null;
  }

  void purchaseCoffee(BuildContext context) {
    if(_pHelper.products.length >= 1)
      _pHelper.makePurchase(_pHelper.products[0]);
    else
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error')));
  }

  bool isItemPurchased(String id) {
    return _pHelper.purchasedProducts.contains(id);
  }

  String getNameOfTheProduct(String fullName) {
    return fullName.split(" ").sublist(0, 3).join(" ");
  }
}