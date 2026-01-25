/// Kamasutra position model
class KamasutraPosition {
  final int id;
  final String name;
  final String image;
  final String description;
  final String? nameKey;  // Localization key for name
  final String? descKey;  // Localization key for description

  KamasutraPosition({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    this.nameKey,
    this.descKey,
  });

  factory KamasutraPosition.fromJson(Map<String, dynamic> json) {
    return KamasutraPosition(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      nameKey: json['nameKey'],
      descKey: json['descKey'],
    );
  }
}
