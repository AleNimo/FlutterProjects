enum Language {
  english(name: 'English', code: 'en'),
  spanish(name: 'Español', code: 'es');

  const Language({
    required this.name,
    required this.code,
  });
  final String name;
  final String code;
}
