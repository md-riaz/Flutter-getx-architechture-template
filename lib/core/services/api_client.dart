import 'dart:async';

class ApiClient {
  Future<List<Map<String, dynamic>>> getInventoryItems(Map<String, dynamic> body) async {
    await Future.delayed(const Duration(milliseconds: 600)); // simulate latency

    return [
      {'id': '1', 'name': 'Laptop', 'quantity': 12},
      {'id': '2', 'name': 'Monitor', 'quantity': 5},
      {'id': '3', 'name': 'Keyboard', 'quantity': 27},
    ];
  }
}
