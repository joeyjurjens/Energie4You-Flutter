import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:energie4you/widgets/app_bar_container.dart';
import 'package:energie4you/widgets/loading_circle.dart';
import 'package:energie4you/db/defect.dart';
import 'package:energie4you/screens/categories_picture_screen.dart';



class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late List<Map<String, Object?>> categories;
  bool isLoading = false;

  @override
  void initState() {
    super.initState(); 
    getAllDefect();
  }

  Future getAllDefect() async {
    setState(() => isLoading = true);
    this.categories = await DefectDatabase.instance.readAllCategories();
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
    } else if(this.categories.length > 0) {
      return getAllDefectCategories();
    } else {
      return Center(
        child: Text("You have not taken any pictures yet.")
      );
    }
  }


  ListView getAllDefectCategories() {
    return ListView.builder(
      itemCount: this.categories.length,
      itemBuilder: (BuildContext context, int position) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 60),
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 70),
            color: Theme.of(context).primaryColor,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CategoriesPictureScreen(
                      categorieString: this.categories[position]["categorie"].toString(),
                    ),
                  ),
                );            
            },
            child: Text(
              this.categories[position]["categorie"].toString().replaceAll("CategorieChoices.", "").toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
            )
            ),
          );
      },
    );
	}
}
