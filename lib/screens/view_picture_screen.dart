import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:energie4you/Helpers/hex_color.dart';
import 'package:energie4you/widgets/app_bar_container.dart';

import 'categories_screen.dart';

class ViewPictureScreen extends StatefulWidget {
  const ViewPictureScreen({Key? key}) : super(key: key);

  @override
  _ViewPictureScreenState createState() => _ViewPictureScreenState();
}

class _ViewPictureScreenState extends State<ViewPictureScreen> {
  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(
        child: Scaffold(
          appBar: AppBarContainer(),
          body: SafeArea(
              child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (builder)=> CategoriesScreen()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black)
                              ),
                              height: 150,
                              width: 150,
                              child: Center(
                                child: Text(
                                  'Categories #1',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  })),
        ),
        value: SystemUiOverlayStyle(
            statusBarColor: colorFromHex(context, '#4b7bec')));
  }
}
