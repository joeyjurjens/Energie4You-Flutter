import 'package:flutter/material.dart';

class ButtonContainer extends StatelessWidget {
  final String imageName;
  final String btnName;
  final bool hasBtn;
  final Function()? onPressed;

  // The constructor that's used when using this widget.
  const ButtonContainer({
    this.hasBtn=true,
    required this.onPressed,
    this.imageName="",
    required this.btnName,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Column(
        children: [
        if(imageName != "") Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black)
              ),
              child: Image.asset(imageName, height: 170, width: 200,)),
         hasBtn ? Container(
            width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor,),
              onPressed: onPressed,
              child: Text(btnName, style: TextStyle(
                fontSize: 17
              ),),
            ),
          ) : Container()
        ],
      ),
    );
  }
}
