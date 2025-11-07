/// Product unit status
enum ProductStatus {
  inStock('in_stock'),
  sold('sold'),
  returned('returned');

  final String value;
  const ProductStatus(this.value);

  static ProductStatus fromString(String value) {
    return ProductStatus.values.firstWhere(
      (s) => s.value == value,
      orElse: () => ProductStatus.inStock,
    );
  }
}

/// Product unit (IMEI-based inventory item)
class ProductUnit {
  final String id;
  final String brandId;
  final String modelId;
  final String imei;
  final String? color;
  final String? ram;
  final String? rom;
  final String? hsn;
  final double purchasePrice;
  final double sellPrice;
  final ProductStatus status;
  final String? purchaseId;
  final String? saleId;

  const ProductUnit({
    required this.id,
    required this.brandId,
    required this.modelId,
    required this.imei,
    this.color,
    this.ram,
    this.rom,
    this.hsn,
    required this.purchasePrice,
    required this.sellPrice,
    required this.status,
    this.purchaseId,
    this.saleId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brandId': brandId,
      'modelId': modelId,
      'imei': imei,
      'color': color,
      'ram': ram,
      'rom': rom,
      'hsn': hsn,
      'purchasePrice': purchasePrice,
      'sellPrice': sellPrice,
      'status': status.value,
      'purchaseId': purchaseId,
      'saleId': saleId,
    };
  }

  factory ProductUnit.fromJson(Map<String, dynamic> json) {
    return ProductUnit(
      id: json['id'] as String,
      brandId: json['brandId'] as String,
      modelId: json['modelId'] as String,
      imei: json['imei'] as String,
      color: json['color'] as String?,
      ram: json['ram'] as String?,
      rom: json['rom'] as String?,
      hsn: json['hsn'] as String?,
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      sellPrice: (json['sellPrice'] as num).toDouble(),
      status: ProductStatus.fromString(json['status'] as String? ?? 'in_stock'),
      purchaseId: json['purchaseId'] as String?,
      saleId: json['saleId'] as String?,
    );
  }

  ProductUnit copyWith({
    String? id,
    String? brandId,
    String? modelId,
    String? imei,
    String? color,
    String? ram,
    String? rom,
    String? hsn,
    double? purchasePrice,
    double? sellPrice,
    ProductStatus? status,
    String? purchaseId,
    String? saleId,
  }) {
    return ProductUnit(
      id: id ?? this.id,
      brandId: brandId ?? this.brandId,
      modelId: modelId ?? this.modelId,
      imei: imei ?? this.imei,
      color: color ?? this.color,
      ram: ram ?? this.ram,
      rom: rom ?? this.rom,
      hsn: hsn ?? this.hsn,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellPrice: sellPrice ?? this.sellPrice,
      status: status ?? this.status,
      purchaseId: purchaseId ?? this.purchaseId,
      saleId: saleId ?? this.saleId,
    );
  }

  @override
  String toString() => 'ProductUnit(id: $id, imei: $imei, status: ${status.value})';
}
