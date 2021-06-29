import 'package:flutter/material.dart';
import 'package:energie4you/Helpers/hex_color.dart';

class LoadingCircle extends StatelessWidget {
  const LoadingCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: CircularProgressIndicator()
    );
  }
}
