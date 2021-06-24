import 'dart:io';

import 'package:flutter/material.dart';
import 'package:energie4you/widgets/app_bar_container.dart';
import 'package:energie4you/screens/home_screen.dart';
import 'package:energie4you/db/defect.dart';
import 'package:energie4you/model/defect.dart';

import 'package:geolocator/geolocator.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

enum CategorieChoices { 
  grondkabels, hoogspanningsmasten, luchtkabels, schakelkasten
}

// Create a Form widget.
class UseThisPictureForm extends StatefulWidget {
  final String imagePath;
  final Defect? defectInstance;

  const UseThisPictureForm({
    Key? key,
    required this.imagePath,
    this.defectInstance=null
  }) : super(key: key);
  
  @override
  UseThisPictureFormState createState() {
    return UseThisPictureFormState();
  }
}

class UseThisPictureFormState extends State<UseThisPictureForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController mechanicController = TextEditingController();
  TextEditingController defectDescriptionController = TextEditingController();
  late CategorieChoices? _categorieChoice = null;
  late Position deviceLocation;
  bool isLoading = false;  
  bool hasDefectInstance = false;

  @override
  void dispose() {
    mechanicController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState(); 

    setState(() => isLoading = true);
    // Only then we need to determine the location.
    if(widget.defectInstance == null) {
      _determinePosition();
    } else {
      setState(() => isLoading = false);
      setState(() => hasDefectInstance = true);

      setState(() => mechanicController.text = widget.defectInstance!.mechanic_name);
      setState(() => defectDescriptionController.text = widget.defectInstance!.description);
    }
  }

  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    }

    this.deviceLocation = await Geolocator.getCurrentPosition();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBarContainer(),
      body: isLoading ? Text("Loading...") : SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Container(
                child: Image.file(File(widget.imagePath), height: 250, width: 250),
                
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Mechanic name",
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: mechanicController,
                          decoration: InputDecoration(
                            helperText: 'Enter the name of the mechanic who looked at the\ndefect here.',
                            labelText: this.hasDefectInstance ? null : 'John doe',
                            border: OutlineInputBorder()
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the name of the mechanic';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Defect description",
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            )
                          ),
                        ),
                        TextFormField(
                            controller: defectDescriptionController,
                            decoration: InputDecoration(
                            helperText: 'Enter a description explaining the defect.',
                            labelText: this.hasDefectInstance ? null : 'Describe the defect here.',
                            border: OutlineInputBorder()
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter at least a small description explaining the defect.';
                            }
                            
                            return null;
                          },
                          minLines: 5,
                          maxLines: 5,
                        )
                      ]
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "GPS coordinates",
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            )
                          ),
                        ), 
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder()
                          ),
                          minLines: 2,
                          maxLines: 2,
                          enabled: false,
                          initialValue: hasDefectInstance ? widget.defectInstance?.gps_coordinates : this.deviceLocation.toString(),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Categorie",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ),
                    Column(
                      children: List.generate(CategorieChoices.values.length, (index) {
                        if(hasDefectInstance) {
                          if(CategorieChoices.values[index].toString() == widget.defectInstance?.categorie.toString()) {
                            _categorieChoice = CategorieChoices.values[index];
                          }
                        }
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
                          String? latLng = hasDefectInstance ? widget.defectInstance?.gps_coordinates : this.deviceLocation.toString();

                          try {
                            if(hasDefectInstance) {
                              updateDefect(mechanicName, defectDescription, categorie, _imagePath, latLng);
                            } else {
                              addDefect(mechanicName, defectDescription, categorie, _imagePath, latLng);
                            }
                          } catch(e) {
                            print(e);
                          }

                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute<void>(builder: (BuildContext context) => const HomeScreen()),
                            ModalRoute.withName(''),                            
                          );
                        }
                      }, 
                      child: Container(
                        padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
                        margin: EdgeInsets.symmetric(vertical:20),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white)
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if(hasDefectInstance) {
                          deleteDefect(widget.defectInstance);
                        }
                      },
                      child: !hasDefectInstance ? Text("") : Container(
                        padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        color: Colors.red,
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.white)
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        emailDefect(widget.defectInstance);
                      },
                      child: !hasDefectInstance ? Text("") : Container(
                        padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
                        color: Colors.green,
                        child: Text(
                          "Email defect",
                          style: TextStyle(color: Colors.white)
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void emailDefect(Defect? instance) async {
    String body = """
    Hello, here's a new defect: \n\n
    Mechanic Name: ${instance!.mechanic_name},
    Defect description: ${instance.description},
    GPS coordinates: ${instance.gps_coordinates},
    Categorie: ${instance.categorie.toString().replaceAll("CategorieChoices.", "").toUpperCase()}
    """;
    final Email email = Email(
      body: body,
      subject: 'Energie4You - Defect',
      recipients: ['example@example.com'],
      attachmentPaths: [instance.imagePath],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }
  
  void addDefect(mechanicName, defectDescription, categorie, imagePath, latLng) async {
    await addDefectAsync(mechanicName, defectDescription, categorie, imagePath, latLng);
  }

  void updateDefect(mechanicName, defectDescription, categorie, imagePath, latLng) async {
    await updateDefectAsync(mechanicName, defectDescription, categorie, imagePath, latLng);
  }

  void deleteDefect(instance) async {
    await deleteDefectAsync(instance);
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (BuildContext context) => const HomeScreen()),
      ModalRoute.withName(''),                            
    );
  }

  Future deleteDefectAsync(instance) async {
    await DefectDatabase.instance.delete(instance);   
  }

  // Method for adding the defect to local DB.
  Future addDefectAsync(mechanicName, defectDescription, categorie, imagePath, latLng) async {
    final defect = Defect(
      mechanic_name: mechanicName,
      description: defectDescription,
      categorie: categorie,
      imagePath: imagePath,
      gps_coordinates: latLng
    );

    Defect instance = await DefectDatabase.instance.create(defect);
    await Navigator.of(context).push(MaterialPageRoute(builder: (builder)=> UseThisPictureForm(imagePath: imagePath, defectInstance: instance)));
  }

  Future updateDefectAsync(mechanicName, defectDescription, categorie, imagePath, latLng) async {
    final defect = widget.defectInstance!.copy(
      mechanic_name: mechanicName,
      description: defectDescription,
      categorie: categorie,
      imagePath: imagePath,
      gps_coordinates: latLng
    );

    await DefectDatabase.instance.update(defect);    
  }
}