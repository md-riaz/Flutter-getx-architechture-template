/// Purchase model
class Purchase {
  final String id;
  final String vendorId;
  final String vendorInvoiceNo;
  final DateTime date;
  final double total;
  final String? notes;

  const Purchase({
    required this.id,
    required this.vendorId,
    required this.vendorInvoiceNo,
    required this.date,
    required this.total,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorId': vendorId,
      'vendorInvoiceNo': vendorInvoiceNo,
      'date': date.toIso8601String(),
      'total': total,
      'notes': notes,
    };
  }

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      id: json['id'] as String,
      vendorId: json['vendorId'] as String,
      vendorInvoiceNo: json['vendorInvoiceNo'] as String,
      date: DateTime.parse(json['date'] as String),
      total: (json['total'] as num).toDouble(),
      notes: json['notes'] as String?,
    );
  }

  @override
  String toString() =>
      'Purchase(id: $id, vendorId: $vendorId, invoiceNo: $vendorInvoiceNo, total: $total)';
}
