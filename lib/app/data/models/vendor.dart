/// Vendor model
class Vendor {
  final String id;
  final String name;
  final String? gst;
  final String? phone;
  final String? email;
  final String? address;

  const Vendor({
    required this.id,
    required this.name,
    this.gst,
    this.phone,
    this.email,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gst': gst,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'] as String,
      name: json['name'] as String,
      gst: json['gst'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
    );
  }

  @override
  String toString() => 'Vendor(id: $id, name: $name, gst: $gst)';
}
