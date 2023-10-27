import 'package:mokata3a/core/firebase_instances.dart';
import 'package:mokata3a/models/coded_product_model.dart';
import 'package:mokata3a/models/productmodel.dart';

Future<List<CodedProduct>> getCodedProducts() async {
  List<CodedProduct> codedProductsList = await fireStore
      .collection('products')
      .get()
      .then((value) =>
          value.docs.map((e) => CodedProduct.fromJson(e.data())).toList());
  return codedProductsList;
}
