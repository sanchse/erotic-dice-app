/// Kamasutra position model
class KamasutraPosition {
  final int id;
  final String name;
  final String image;
  final String description;

  KamasutraPosition({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
  });

  factory KamasutraPosition.fromJson(Map<String, dynamic> json) {
    return KamasutraPosition(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
    );
  }
}
