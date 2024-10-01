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

  Tree({
    this.id,
    required this.name,
    required this.scientificName,
    required this.family,
    required this.quantityBsAs,
  });

  Tree copyWith({
    int? id,
    String? name,
    String? scientificName,
    String? family,
    int? quantityBsAs,
  }) {
    return Tree(
      id: id ?? this.id,
      name: name ?? this.name,
      scientificName: scientificName ?? this.scientificName,
      family: family ?? this.family,
      quantityBsAs: quantityBsAs ?? this.quantityBsAs,
    );
  }
}
