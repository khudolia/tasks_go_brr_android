import 'package:tasks_go_brr/utils/purchase_helper.dart';

class PurchaseViewModel {
  PurchaseHelper _pHelper = PurchaseHelper();

  initPurchase() async {
    await _pHelper.init();
  }

  void purchaseCoffee() {
    _pHelper.makePurchase(_pHelper.products[0]);
  }
}