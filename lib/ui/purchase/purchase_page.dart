import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _model.initPurchase(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.only(
                      topLeft: Radiuss.middle, topRight: Radiuss.middle)),
              child: Container(
                margin: EdgeInsets.only(
                  top: Margin.middle_smaller.h,
                ),
                child: _buttonsList(),
              ),
            );
          } else {
            return Container();
          }
        });
  }

  Widget _buttonsList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _purchaseButton("By dev coffee", "25.00", () => _model.purchaseCoffee())
      ],
    );
  }

  Widget _purchaseButton(String text, String price, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Margin.middle.w,
      ),
      child: AnimatedGestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Paddings.big_smaller.w,
            vertical: Paddings.middle.h
          ),
          width: double.infinity,
          decoration: BoxDecoration(
              color: context.surfaceAccent,
              borderRadius: BorderRadius.all(Radiuss.small)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text, style: TextStyle(
                color: context.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: Dimens.text_normal_bigger
              ),),
              SizedBox(
                height: Margin.small.h,
              ),
              Text(price, style: TextStyle(
                color: context.onSurface,
                fontWeight: FontWeight.w500,
                  fontSize: Dimens.text_normal_smaller
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
