/// Customer model
class Customer {
  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? gst;

  const Customer({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.gst,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'gst': gst,
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      gst: json['gst'] as String?,
    );
  }

  @override
  String toString() => 'Customer(id: $id, name: $name, phone: $phone)';
}
