/// Sale model
class Sale {
  final String id;
  final String customerId;
  final String invoiceNo;
  final DateTime date;
  final double taxable;
  final double cgst;
  final double sgst;
  final double igst;
  final double total;
  final String payMode;
  final Map<String, dynamic>? emi;
  final String? terms;

  const Sale({
    required this.id,
    required this.customerId,
    required this.invoiceNo,
    required this.date,
    required this.taxable,
    required this.cgst,
    required this.sgst,
    required this.igst,
    required this.total,
    required this.payMode,
    this.emi,
    this.terms,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'invoiceNo': invoiceNo,
      'date': date.toIso8601String(),
      'taxable': taxable,
      'cgst': cgst,
      'sgst': sgst,
      'igst': igst,
      'total': total,
      'payMode': payMode,
      'emi': emi,
      'terms': terms,
    };
  }

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      invoiceNo: json['invoiceNo'] as String,
      date: DateTime.parse(json['date'] as String),
      taxable: (json['taxable'] as num).toDouble(),
      cgst: (json['cgst'] as num).toDouble(),
      sgst: (json['sgst'] as num).toDouble(),
      igst: (json['igst'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      payMode: json['payMode'] as String,
      emi: json['emi'] as Map<String, dynamic>?,
      terms: json['terms'] as String?,
    );
  }

  @override
  String toString() => 'Sale(id: $id, invoiceNo: $invoiceNo, total: $total)';
}
