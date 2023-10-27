import 'package:carbon_icons/carbon_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mokata3a/constant/style.dart';
import 'package:mokata3a/core/firebase_instances.dart';
import 'package:mokata3a/logic/database_functions.dart';
import 'package:mokata3a/logic/view_functions.dart';
import 'package:mokata3a/models/coded_product_model.dart';
import 'package:mokata3a/screens/barcoderesultscreen/bar_code_result_screen.dart';
import 'package:mokata3a/screens/searchscreen/searchscreen.dart';
import 'package:mokata3a/widgets/DefaultTextStyle/defaultextstyle.dart';
import 'package:mokata3a/widgets/defaultbuttomn/defaultbuttomn.dart';
import 'package:mokata3a/widgets/mytextfromfield/my_textfrom_field.dart';
import 'package:mokata3a/widgets/mytoast/mytoast.dart';
import 'package:page_transition/page_transition.dart';

import '../../models/productmodel.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController searchProduct = TextEditingController();

  List<Product> productList = [];
  List<Product> matchingProducts = [];
  List<CodedProduct> codedProducts = [];

  searchHited() {
    if (searchProduct.text.isEmpty) {
      showtoast("الرجاء ادخال ما تريد البحث عنه");
    } else {
      searchProducts(searchProduct.text);

      Navigator.push(
          context,
          PageTransition(
              duration: const Duration(
                milliseconds: 300,
              ),
              type: PageTransitionType.leftToRight,
              child: SearchScreen(
                searchProductList: matchingProducts,
              )));
    }
  }

  void searchProducts(String searchname) {
    matchingProducts.clear();

    for (Product product in productList) {
      if (product.productname.contains(searchname)) {
        setState(() {
          matchingProducts.add(product);
          print(matchingProducts);
        });
      }
    }
  }

  //its better to use state mangement providers ,
  // here we need some refactoring to seperate buisness logic from ui , but we have a lack of time so we will ignore it
  fetchproducts() {
    databaseReference.child("products").once().then((snap) {
      if (snap.snapshot.value != null) {
        (snap.snapshot.value as Map).forEach((key, value) {
          Product product = Product(
            productname: key,
            state: value["state"],
          );
          setState(() {
            productList.add(product);
          });
        });
      }
    });
  }

  @override
  void initState() {
    fetchproducts();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: maincolor,
        title: MyDefaultTextStyle(
            text: "المقاطعة كفاح", height: height * 0.025, bold: true),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: height * 0.04),
                  height: height * 0.03,
                  width: width * 0.03,
                  decoration:
                      BoxDecoration(color: white, shape: BoxShape.circle),
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                Container(
                  alignment: Alignment.center,
                  child: MyDefaultTextStyle(
                      text: ".مقاطعة",
                      height: height * 0.06,
                      bold: true,
                      color: maincolor),
                ),
                Container(
                    margin: EdgeInsets.only(
                        top: height * 0.04,
                        left: width * 0.03,
                        right: width * 0.03),
                    child: TextField(
                      cursorColor: white,
                      controller: searchProduct,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: width * 0.1, vertical: 14),
                          prefixIcon: InkWell(
                            onTap: () => searchHited(),
                            child: Container(
                              padding: EdgeInsets.all(height * 0.001),
                              decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Icon(
                                Icons.search,
                                color: white,
                                size: 20,
                              ),
                            ),
                          ),
                          fillColor:
                              Color.fromARGB(72, 1, 175, 117).withOpacity(0.2),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: white, width: 2)),
                          hintText: "ابحث عن المنتج",
                          hintStyle: TextStyle(
                              color: black.withOpacity(0.7), fontSize: 13),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white))),
                    )),
                Container(
                  margin: EdgeInsets.only(
                      top: width * 0.01,
                      left: width * 0.03,
                      right: width * 0.03),
                  child: Defaultbutton(
                      functon: () async {
                        String barCode = await getProductBarCode();
                        print(barCode);

                        List<CodedProduct> products = await getCodedProducts();
                        print(products);
                        bool isProductBoyCoted = false;
                        late CodedProduct codedProduct;

                        products.forEach((e) {
                          print(e.barCode);
                          if (e.barCode == barCode) {
                            isProductBoyCoted = true;
                            codedProduct = e;
                          }
                        });
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BarCodeResultScreen(
                              codedProduct: isProductBoyCoted
                                  ? codedProduct
                                  : CodedProduct(
                                      name:
                                          'لا يوجد في قاعدة بيانات منتجات المقاطعة',
                                      barCode: barCode,
                                      isBoyCotted: false)),
                        ));
                      },
                      color: maincolor,
                      text: 'فحص ببار كود',
                      icon: Icon(
                        CarbonIcons.barcode,
                        color: Colors.white,
                      ),
                      height: height * 0.067,
                      fontsize: 13,
                      width: width),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: width * 0.03, right: width * 0.03),
                  child: MyDefaultTextStyle(
                      text: "اهم المنتجات التي يجب مقاطعتها",
                      height: height * 0.020,
                      bold: true,
                      color: black),
                ),
                productList.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: height * 0.08),
                        child: const CircularProgressIndicator(
                          color: maincolor,
                        ),
                      )
                    : Container(
                        alignment: Alignment.centerRight,
                        width: width,
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 8,
                            itemBuilder: (context, index) {
                              return productList[index].state
                                  ? Container(
                                      alignment: Alignment.centerRight,
                                      margin: EdgeInsets.only(
                                          left: width * 0.03,
                                          right: width * 0.03,
                                          top: height * 0.02),
                                      height: height * 0.08,
                                      width: width * 0.8,
                                      decoration: BoxDecoration(
                                          color: white,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: width * 0.02),
                                            child: MyDefaultTextStyle(
                                                text: "يجب مقاطعته",
                                                height: height * 0.018,
                                                color: Colors.red),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: width * 0.02),
                                            child: MyDefaultTextStyle(
                                                text: productList[index]
                                                    .productname,
                                                bold: true,
                                                height: height * 0.018,
                                                color: black),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container();
                            }),
                      ),
                SizedBox(
                  height: height * 0.02,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
