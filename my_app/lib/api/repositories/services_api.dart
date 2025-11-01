import 'package:dio/dio.dart';

import 'package:my_app/services/models/service.dart';
import 'package:my_app/services/services_repository.dart';

class ServicesApi implements ServicesDataSource {
  ServicesApi(this._dio);

  final Dio _dio;

  @override
  Future<List<Service>> loadServices() async {
    final response = await _dio.get('/services');
    final data = response.data;
    if (data is List) {
      return data
          .map((entry) =>
              Service.fromJson(Map<String, dynamic>.from(entry as Map)))
          .toList();
    }
    return const [];
  }

  @override
  Future<Service?> getServiceById(String id) async {
    if (id.isEmpty) {
      return null;
    }
    try {
      final response = await _dio.get('/services/$id');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return Service.fromJson(data);
      }
    } on DioException {
      // ignore and fall back to null
    }
    // Fallback: fetch all services and find the match
    final services = await loadServices();
    for (final service in services) {
      if (service.id == id) {
        return service;
      }
    }
    return null;
  }
}
