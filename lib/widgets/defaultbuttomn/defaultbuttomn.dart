import 'package:flutter/material.dart';

import '../../constant/style.dart';

Widget Defaultbutton({
  required functon,
  Color color = Colors.blue,
  Color textcolor = white,
  required String text,
  double border = 10.0,
  double fontsize = 18,
  required double height,
  Icon? icon,
  required double width,
  bool isloading = false,
}) {
  return Container(
    width: width,
    height: height,
    child: ElevatedButton(
      onPressed: functon,
      child: isloading
          ? CircularProgressIndicator(
              color: white,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                icon == null ? SizedBox() : icon,
                Text(
                  text,
                  style: TextStyle(
                    color: textcolor,
                    fontSize: fontsize,
                  ),
                ),
              ],
            ),
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(border))),
      ),
    ),
  );
}
