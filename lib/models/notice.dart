enum NoticeType { event, info }

class Notice {
  final String id;
  final String title;
  final String description;
  final DateTime postedDate;
  final NoticeType type;
  final String? imageAsset;

  const Notice({
    required this.id,
    required this.title,
    required this.description,
    required this.postedDate,
    required this.type,
    this.imageAsset,
  });

  String get typeLabel => type == NoticeType.event ? 'EVENT' : 'INFO';

  String get titleKey => '${id}_title';
  String get descKey => '${id}_desc';
}
