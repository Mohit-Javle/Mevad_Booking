class Event {
  final String id;
  final String title;
  final DateTime date;
  final String location;
  final String? description;
  final String? imageAsset;

  const Event({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    this.description,
    this.imageAsset,
  });

  String get titleKey => '${id}_title';
  String get locationKey => '${id}_loc';
}
