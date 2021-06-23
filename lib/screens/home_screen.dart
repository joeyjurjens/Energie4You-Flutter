import 'dart:async';

import 'package:camera/camera.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:energie4you/Helpers/hex_color.dart';
import 'package:energie4you/widgets/button_container.dart';
import 'package:energie4you/widgets/app_bar_container.dart';

import '../Screens/take_picture_screen.dart';
import '../Screens/categories_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    cameras = await availableCameras();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        child: Scaffold(
          appBar: AppBarContainer(),
          body: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Container(
                    alignment: Alignment.center,
                    child: ButtonContainer(
                      imageName: 'assets/camera.png',
                      btnName: 'Take a picture',
                      hasBtn: true,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> TakePictureScreen(camera: cameras.first,)));
                      }
                    )),
                ButtonContainer(
                  imageName: 'assets/gallery.png',
                  btnName: 'View pictures',
                  hasBtn: true,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> CategoriesScreen()));
                  }
                )
              ],
            ),
          )),
        ),
        value: SystemUiOverlayStyle(
            statusBarColor: colorFromHex(context, '#4b7bec')));
  }
}
