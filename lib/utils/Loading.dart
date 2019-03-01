import 'package:flutter/material.dart';

class Loading {
  static hideLoading(context){
    Navigator.pop(context);
  }


  static showLoading(context) {
    // Navigator.of(context).push(Builder: () {});
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child:CircularProgressIndicator()
          );
          // return SpinKitFadingCircle(
          //   itemBuilder: (_, int index) {
          //     return DecoratedBox(
          //       decoration: BoxDecoration(
          //         color: index.isEven ? Colors.red : Colors.green,
          //       ),
          //     );
          //   },
          // );
        });
  }
}
