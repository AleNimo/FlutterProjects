import 'package:floor/floor.dart';

@entity
class Tree {
  //si lo pongo en minúscula primaryKey no toma atributos
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String scientificName;
  final String family;
  final int quantityBsAs;
  final String? imageURL;

  Tree({
    this.id,
    required this.name,
    required this.scientificName,
    required this.family,
    required this.quantityBsAs,
    this.imageURL,
  });
}
