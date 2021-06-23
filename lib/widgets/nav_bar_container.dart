import 'package:flutter/material.dart';
import 'package:energie4you/Helpers/hex_color.dart';

class NavBarContainer extends StatelessWidget {

  final String text;
   final bool hasBorder;

  const NavBarContainer({required this.text, this.hasBorder = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: GestureDetector(
        onTap: (){
            return null;
        },
        child: Container(
          decoration: BoxDecoration(
              color: colorFromHex(context, '#4b7bec'),
              border:  hasBorder ? Border(right: BorderSide(
                  color: Colors.white, width: 1
              )) : null
          ),
          height: 50,

          child: Center(
            child: Text(text, style: TextStyle(
                color: Colors.white, fontSize: 18
            ),),
          ),
        ),
      ),
    );
  }
}
