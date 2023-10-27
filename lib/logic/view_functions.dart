import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

Future<String> getProductBarCode() async {
  String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      "#ffffff", 'Cancel', true, ScanMode.BARCODE);
  return barcodeScanRes;
}
