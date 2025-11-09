import 'package:equatable/equatable.dart';

class Experience extends Equatable {
  final int id;
  final String name;
  final String tagline;
  final String description;
  final String imageUrl;
  final String iconUrl;

  const Experience({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.imageUrl,
    required this.iconUrl,
  });

  factory Experience.fromJson(Map<String, dynamic> j) => Experience(
    id: (j['id'] is int) ? j['id'] as int : int.tryParse('${j['id']}') ?? 0,
    name: (j['name'] ?? '').toString(),
    tagline: (j['tagline'] ?? '').toString(),
    description: (j['description'] ?? '').toString(),
    imageUrl: (j['image_url'] ?? '').toString(),
    iconUrl: (j['icon_url'] ?? '').toString(),
  );

  @override
  List<Object?> get props => [
    id,
    name,
    tagline,
    description,
    imageUrl,
    iconUrl,
  ];
}
