final String tableDefect = "defect";

class DefectFields {
  static final String id = '_id';
  static final String imagePath = 'imagePath';
  static final String gps_coordinates = 'gps_coordinates';
  static final String mechanic_name = 'mechanic_name';
  static final String description = 'description';
  static final String categorie = 'categorie';

  static final List<String> values = [
    id, imagePath, gps_coordinates, mechanic_name, description, categorie
  ];
}

class Defect {
  final int? id;
  final String imagePath;
  final String gps_coordinates;
  final String mechanic_name;
  final String description;
  final String categorie;

  const Defect({
    this.id,
    required this.imagePath,
    required this.gps_coordinates,
    required this.mechanic_name,
    required this.description,
    required this.categorie
  });

  Defect copy({
    int? id,
    String? imagePath,
    String? gps_coordinates,
    String? mechanic_name,
    String? description,
    String? categorie,
  }) => Defect(
    id: id ?? this.id,
    imagePath: imagePath ?? this.imagePath,
    gps_coordinates: gps_coordinates ?? this.gps_coordinates,
    mechanic_name: mechanic_name ?? this.mechanic_name,
    description: description ?? this.description,
    categorie: categorie ?? this.categorie,
  );

  Map<String, Object?> toJson() => {
    DefectFields.id: id,
    DefectFields.imagePath: imagePath,
    DefectFields.gps_coordinates: gps_coordinates,
    DefectFields.mechanic_name: mechanic_name,
    DefectFields.description: description,
    DefectFields.categorie: categorie,
  };

  static Defect fromJson(Map<String, Object?> json) => Defect(
    id: json[DefectFields.id] as int?,
    imagePath: json[DefectFields.imagePath] as String,
    gps_coordinates: json[DefectFields.gps_coordinates] as String,
    mechanic_name: json[DefectFields.mechanic_name] as String,
    description: json[DefectFields.description] as String,
    categorie: json[DefectFields.categorie] as String,                
  );
}