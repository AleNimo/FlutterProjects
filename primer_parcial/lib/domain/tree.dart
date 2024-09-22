class Tree {
  final String id;
  final String name;
  final String scientificName;
  final String family;
  final int quantityBsAs;
  final String? imageURL;

  Tree({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.family,
    required this.quantityBsAs,
    this.imageURL,
  });
}
