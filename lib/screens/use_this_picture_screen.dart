import 'package:flutter/material.dart';
import 'package:energie4you/widgets/app_bar_container.dart';
import 'package:energie4you/db/defect.dart';
import 'package:energie4you/model/defect.dart';

enum CategorieChoices { 
  grondkabels, hoogspanningsmasten, luchtkabels, schakelkasten
}

// Create a Form widget.
class UseThisPictureForm extends StatefulWidget {
  final String imagePath;

  const UseThisPictureForm({
    Key? key,
    required this.imagePath,
  }) : super(key: key);
  
  @override
  UseThisPictureFormState createState() {
    return UseThisPictureFormState();
  }
}

class UseThisPictureFormState extends State<UseThisPictureForm> {
  final _formKey = GlobalKey<FormState>();
  final mechanicController = TextEditingController();
  final defectDescriptionController = TextEditingController();
  late CategorieChoices? _categorieChoice = null;

  @override
  void dispose() {
    mechanicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBarContainer(),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: mechanicController,
                  decoration: const InputDecoration(
                    helperText: 'Enter the name of the mechanic who looked at the\ndefect here.',
                    labelText: 'Mechanic name',
                  ),            
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name of the mechanic';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: defectDescriptionController,
                  decoration: const InputDecoration(
                    helperText: 'Enter a description explaining the defect.',
                    labelText: 'Defect description',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter at least a small description explaining the defect.';
                    }
                    return null;
                  },
                  minLines: 5,
                  maxLines: 5,
                ),
                Column(
                  children: List.generate(CategorieChoices.values.length, (index){
                    return ListTile(
                      title: Text(CategorieChoices.values[index].toString().replaceAll("CategorieChoices.", "").toUpperCase()),
                      leading: Radio<CategorieChoices>(
                        value: CategorieChoices.values[index],
                        groupValue: _categorieChoice,
                        onChanged: (CategorieChoices? value) {
                          setState(() {
                            _categorieChoice = value;
                          });
                        },
                      ),
                    ); 
                  }),
                ),
                TextButton(
                  onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        String mechanicName = mechanicController.text;
                        String defectDescription = defectDescriptionController.text;
                        String categorie = _categorieChoice.toString();
                        String _imagePath = widget.imagePath;

                        try {
                          addDefect(mechanicName, defectDescription, categorie, _imagePath);
                        } catch(e) {
                          print(e);
                        }
                      }
                  }, 
                  child: Container(
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white)
                    ),
                  ),
                )
              ],
            ),
          ),            
          ],
        )
      )
    );
  }

  // Method for adding the defect to local DB.
  void addDefect(mechanicName, defectDescription, categorie, imagePath) async {
    await addDefectAsync(mechanicName, defectDescription, categorie, imagePath);
  }

  // Method for adding the defect to local DB.
  Future addDefectAsync(mechanicName, defectDescription, categorie, imagePath) async {
    final defect = Defect(
      mechanic_name: mechanicName,
      description: defectDescription,
      categorie: categorie,
      imagePath: imagePath,
      gps_coordinates: "henk"
    );

    await DefectDatabase.instance.create(defect);    
  }  
}