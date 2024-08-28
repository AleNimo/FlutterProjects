class Policy {
  final String id;
  final String name;
  final String description;
  final String date;
  final int trainedEpisodes;
  final String? imageURL;

  Policy({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.trainedEpisodes,
    this.imageURL,
  });
}
