import 'dart:io';

import 'package:flutter/material.dart';
import 'package:energie4you/widgets/button_container.dart';
import 'package:energie4you/Screens/use_this_picture_screen.dart';
import 'package:energie4you/widgets/app_bar_container.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  const DisplayPictureScreen({required this.imagePath, Key? key}) : super(key: key);

  @override
  _DisplayPictureScreen createState() => _DisplayPictureScreen();
}

class _DisplayPictureScreen extends State<DisplayPictureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarContainer(),
      body: Image.file(File(widget.imagePath)),
      bottomNavigationBar: Container(
        height: 50,
        child: Row(
          children: [
            Expanded(child: 
              ButtonContainer(
                btnName: 'Use this',
                hasBtn: true,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> UseThisPictureForm(imagePath: widget.imagePath,)));
                }
              )
            )
          ],
        ),
      ),
    );
  }
}
