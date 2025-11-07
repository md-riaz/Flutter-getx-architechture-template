/// Brand model
class Brand {
  final String id;
  final String name;

  const Brand({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  @override
  String toString() => 'Brand(id: $id, name: $name)';
}
