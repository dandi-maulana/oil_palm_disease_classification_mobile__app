// lib/models/disease_sample.dart
class DiseaseSample {
  final String id;
  final String name;
  final String imagePath;
  final String description;
  final String solution;

  DiseaseSample({
    required this.id, required this.name, required this.imagePath,
    required this.description, required this.solution,
  });

  factory DiseaseSample.fromJson(Map<String, dynamic> json) {
    return DiseaseSample(
      id: json['id'],
      name: json['name'],
      imagePath: json['imagePath'],
      description: json['description'],
      solution: json['solution'],
    );
  }
}