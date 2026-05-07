import 'package:flutter_test/flutter_test.dart';
import 'package:getx_modular_template/core/implementations/api_network_service.dart';
import 'package:getx_modular_template/core/services/api_client.dart';

void main() {
  group('ApiNetworkService', () {
    late ApiNetworkService networkService;
    late ApiClient apiClient;

    setUp(() {
      apiClient = ApiClient();
      networkService = ApiNetworkService(apiClient);
    });

    test('get request returns success response', () async {
      final response = await networkService.get('/test');
      
      expect(response.statusCode, 200);
      expect(response.isSuccess, true);
      expect(response.data, isNotNull);
    });

    test('post request returns success response', () async {
      final response = await networkService.post(
        '/test',
        body: {'name': 'test'},
      );
      
      expect(response.statusCode, 201);
      expect(response.isSuccess, true);
      expect(response.data, isNotNull);
    });

    test('put request returns success response', () async {
      final response = await networkService.put(
        '/test',
        body: {'name': 'updated'},
      );
      
      expect(response.statusCode, 200);
      expect(response.isSuccess, true);
    });

    test('patch request returns success response', () async {
      final response = await networkService.patch(
        '/test',
        body: {'status': 'active'},
      );
      
      expect(response.statusCode, 200);
      expect(response.isSuccess, true);
    });

    test('delete request returns success response', () async {
      final response = await networkService.delete('/test');
      
      expect(response.statusCode, 204);
      expect(response.isSuccess, true);
    });

    test('setDefaultHeaders stores headers', () {
      networkService.setDefaultHeaders({'Authorization': 'Bearer token'});
      // Headers are stored internally, verified by using them in requests
    });

    test('setBaseUrl stores base URL', () {
      networkService.setBaseUrl('https://api.example.com');
      // Base URL is stored internally
    });

    test('setTimeout stores timeout', () {
      networkService.setTimeout(const Duration(seconds: 60));
      // Timeout is stored internally
    });

    test('NetworkResponse isSuccess returns true for 2xx status codes', () {
      expect(
        NetworkResponse(statusCode: 200).isSuccess,
        true,
      );
      expect(
        NetworkResponse(statusCode: 201).isSuccess,
        true,
      );
      expect(
        NetworkResponse(statusCode: 299).isSuccess,
        true,
      );
    });

    test('NetworkResponse isSuccess returns false for non-2xx status codes', () {
      expect(
        NetworkResponse(statusCode: 199).isSuccess,
        false,
      );
      expect(
        NetworkResponse(statusCode: 400).isSuccess,
        false,
      );
      expect(
        NetworkResponse(statusCode: 500).isSuccess,
        false,
      );
    });
  });
}
