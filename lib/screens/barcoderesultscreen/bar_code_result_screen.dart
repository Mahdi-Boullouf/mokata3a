import 'package:flutter/material.dart';
import 'package:mokata3a/constant/style.dart';
import 'package:mokata3a/core/assets_manager.dart';
import 'package:mokata3a/models/coded_product_model.dart';
import 'package:mokata3a/widgets/DefaultTextStyle/defaultextstyle.dart';

class BarCodeResultScreen extends StatelessWidget {
  const BarCodeResultScreen({super.key, required this.codedProduct});
  final CodedProduct codedProduct;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Widget okTobuyWidgets() {
      return Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: height * 0.2,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(AssetsManager.safeToBuyAsset),
            ),
            Text(
              codedProduct.name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            // SizedBox(
            //   height: height * 0.01,
            // ),
            // Text(
            //   'لا يجب مقاطعته',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //       color: Colors.teal, fontSize: 18, fontWeight: FontWeight.bold),
            // )
          ],
        ),
      );
    }

    Widget notOkTobuyWidgets() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: height * 0.2,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.notSafeToBuyAsset),
          ),
          Text(
            codedProduct.name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Text(
            'يجب مقاطعته',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
          )
        ],
      );
    }

    return Scaffold(
      body: Center(
          child: codedProduct.isBoyCotted
              ? notOkTobuyWidgets()
              : okTobuyWidgets()),
    );
  }
}
