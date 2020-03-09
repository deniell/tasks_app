import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: SpinKitPouringHourglass(
          color: Colors.blue,
          size: 100.0,
        ),
      ),
    );
  }
}