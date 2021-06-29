import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:energie4you/widgets/app_bar_container.dart';
import 'package:energie4you/widgets/loading_circle.dart';
import 'package:energie4you/db/defect.dart';
import 'package:energie4you/model/defect.dart';
import 'package:energie4you/Screens/use_this_picture_screen.dart';

class CategoriesPictureScreen extends StatefulWidget {
  final String categorieString;
  
  
  const CategoriesPictureScreen({
    Key? key,
    required this.categorieString,
  }) : super(key: key);

  @override
  _CategoriesPictureScreenState createState() =>
      _CategoriesPictureScreenState();
}

class _CategoriesPictureScreenState extends State<CategoriesPictureScreen> {
  late List<Defect> pictures;
  bool isLoading = false;

  @override
  void initState() {
    super.initState(); 
    getAllDefect();
  }

  Future getAllDefect() async {
    setState(() => isLoading = true);
    this.pictures = await DefectDatabase.instance.readCategorieDefects(widget.categorieString);
    setState(() => isLoading = false);
  }
  
  @override
  Widget build(BuildContext context) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
        child: Scaffold(
          appBar: AppBarContainer(),
          body: makeBody(),
        ),
        value: SystemUiOverlayStyle(statusBarColor: Theme.of(context).primaryColor)
    );
  }

  Widget makeBody() {
    if(isLoading) {
      return LoadingCircle();
    } else {
      return getAllPicturesListView();
    }
  }

  GridView getAllPicturesListView() {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(this.pictures.length, (index) {
        Defect defectInstance = this.pictures[index];
        String imagePath = defectInstance.imagePath;
        return Center(
          child: Container(
            padding: EdgeInsets.all(10),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> UseThisPictureForm(imagePath: imagePath, defectInstance: defectInstance,)));
              },
              child: Image.file(File(imagePath))
            ),
          ),
        );
      }),
    );
}
}