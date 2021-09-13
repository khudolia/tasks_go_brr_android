import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tasks_go_brr/resources/dimens.dart';
import 'package:tasks_go_brr/resources/colors.dart';
import 'package:tasks_go_brr/ui/custom/animated_gesture_detector.dart';
import 'package:tasks_go_brr/ui/purchase/purchase_view_model.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({Key? key}) : super(key: key);

  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  final PurchaseViewModel _model = PurchaseViewModel();

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.only(
              topLeft: Radiuss.middle, topRight: Radiuss.middle)),
      child: Container(
        margin: EdgeInsets.only(
          top: Margin.middle_smaller.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder(
                future: _model.initPurchase(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return _buttonsList();
                  } else {
                    return Container(
                      child: CircularProgressIndicator(
                        color: context.primary,
                      ),
                      margin: EdgeInsets.only(bottom: Margin.middle.h),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _buttonsList() {
    return StreamBuilder<List<ProductDetails>>(
      initialData: [],
      stream: _model.sPurchasedProducts.stream,
      builder: (context, snapshot) {
        var _coffeeDetails = _model.getCoffeeDetails();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _purchaseButton(
              price: "${_coffeeDetails.price}",
              text: _coffeeDetails.title,
              onTap: () => _model.purchaseCoffee(context),
              isPurchased: _model.isItemPurchased(_coffeeDetails.id),
            ),
            SizedBox(
              height: Margin.middle.h,
            ),
          ],
        );
      },
    );
  }

  Widget _purchaseButton({
    required String text,
    required String price,
    required VoidCallback onTap,
    required bool isPurchased,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Margin.middle.w,
      ),
      child: AnimatedGestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Paddings.big_smaller.w,
            vertical: Paddings.middle.h,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.surfaceAccent,
            borderRadius: BorderRadius.all(Radiuss.small),
          ),
          child: !isPurchased
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        color: context.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: Dimens.text_normal_bigger,
                      ),
                    ),
                    SizedBox(
                      height: Margin.small.h,
                    ),
                    Text(
                      price,
                      style: TextStyle(
                        color: context.onSurface,
                        fontWeight: FontWeight.w500,
                        fontSize: Dimens.text_normal_smaller,
                      ),
                    ),
                  ],
                )
              : Text(
                  "thank_for_purchasing".tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: context.onSurface,
                    fontSize: Dimens.text_normal_bigger,
                  ),
                ),
        ),
      ),
    );
  }
}
