/// Model (phone model) model
class PhoneModel {
  final String id;
  final String brandId;
  final String name;

  const PhoneModel({
    required this.id,
    required this.brandId,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brandId': brandId,
      'name': name,
    };
  }

  factory PhoneModel.fromJson(Map<String, dynamic> json) {
    return PhoneModel(
      id: json['id'] as String,
      brandId: json['brandId'] as String,
      name: json['name'] as String,
    );
  }

  @override
  String toString() => 'PhoneModel(id: $id, brandId: $brandId, name: $name)';
}
