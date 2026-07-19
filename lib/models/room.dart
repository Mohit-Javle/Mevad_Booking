class Room {
  final String id;
  final String name;
  final String description;
  final String imageAsset;
  final int capacity;
  final double pricePerNight;
  final List<String> amenities;
  final int availableCount;
  final bool isAC;

  const Room({
    required this.id,
    required this.name,
    required this.description,
    required this.imageAsset,
    required this.capacity,
    required this.pricePerNight,
    required this.amenities,
    required this.availableCount,
    required this.isAC,
  });

  String get nameKey => '${id}_name';
  String get descKey => '${id}_desc';
}
