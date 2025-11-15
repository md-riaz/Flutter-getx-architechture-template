class InventoryRequest {
  final String warehouseId;

  InventoryRequest({required this.warehouseId});

  Map<String, dynamic> toJson() => {
        'warehouse_id': warehouseId,
      };
}
