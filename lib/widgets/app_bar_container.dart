import 'package:flutter/material.dart';


class AppBarContainer extends StatefulWidget implements PreferredSizeWidget {
  AppBarContainer({Key? key}) : preferredSize = Size.fromHeight(60.0), super(key: key);

  @override
  final Size preferredSize;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<AppBarContainer>{

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Energie4You',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white),
      ),
    );
  }
}